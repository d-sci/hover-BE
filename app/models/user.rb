class User < ApplicationRecord
  before_save { email.downcase! } 
  validates(:email, 
            presence: true, 
            length: {maximum: 255}, 
            uniqueness: { case_sensitive: false },
            format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
            )
  has_secure_password
  validates(:password, 
            presence: true, 
            length: { minimum: 6 },
            allow_nil: true #for updating (has_secure won't allow for new)
            )
  has_many :pools
  has_many :trips, through: :pools
  has_many :in_requests, class_name: "Request", foreign_key: "to_user_id"
  has_many :out_requests, class_name: "Request", foreign_key: "from_user_id"
  mount_base64_uploader :avatar, AvatarUploader
  
  
  attr_accessor :activation_code, :reset_code
  
  # Creates a hash of a code
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Generates a random 6-character code (alphanum, all lowercase)
  def User.new_code
    SecureRandom.urlsafe_base64[0..5].gsub('-','0').gsub('_','9').downcase
  end
  
  # Sets the account activation attributes
    def create_activation_digest
      self.activation_code  = User.new_code
      update_columns(activation_digest: User.digest(activation_code), 
                    activation_sent_at: Time.zone.now)
    end
    
  # Sends account activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_code = User.new_code
    update_columns(reset_digest: User.digest(reset_code), 
                    reset_sent_at: Time.zone.now)
  end
  
  # Sends password reset email
  def send_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # Authenticate a user by activation or reset code (case-insensitive)
  def authenticate_by_code(action, code)
    digest = self.send("#{action}_digest")
    sent_at = self.send("#{action}_sent_at")
    return false if digest.nil? or sent_at < 2.hours.ago
    BCrypt::Password.new(digest).is_password?(code.downcase)
  end
  
  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  # Compatability between users, based only on their preferences (quite arbitrary atm)
  def compatibility(other)
    compat = 100
    compat -= 4 unless driving_pref + other.driving_pref == 0
    compat -= 5 if gender != other.gender
    compat -= 6 if company != other.company
    compat -= 3*(talkativeness-other.talkativeness).abs
    compat -= 20 if smoke != other.smoke
    compat -= 10 if ac != other.ac
    if radio_stations.length >= other.radio_stations.length
      stations1 = radio_stations
      stations2 = other.radio_stations
    else
      stations1 = other.radio_stations
      stations2 = radio_stations
    end
    stations1.each {|s| compat -= 1 unless stations2.include?(s)}
    return compat
  end
  
  # Return all the people you are in active carpools with. Potentially useful but not yet used.
  def active_copoolers
    sql = "SELECT DISTINCT ON (u.id) u.* FROM users u JOIN pools p ON p.user_id = u.id
            WHERE p.is_active = true
              AND p.user_id != :uid
              AND p.trip_id in (:tids)"
    vars = {uid: id, tids: trips.ids}
    @active_copoolers = User.find_by_sql [sql,vars]
  end
  
  # Return your active carpool trips
  def active_carpools
    @active_carpools = trips.where('pools.is_active': true).where.not(driver_id: 0)
  end
  
  # Return your pending carpool trips
  def pending_carpools
    @pending_carpools = trips.where('pools.is_pending': true)
  end
  
  # Return your personal trips, active or not
  def personal_trips
    @personal_trips = trips.where(driver_id: 0)
  end
  
  
end
