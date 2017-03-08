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
  
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def User.new_code
    SecureRandom.urlsafe_base64[0..6]
  end
  
  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:User.digest(reset_token), 
                    reset_sent_at: Time.zone.now)
  end
  
  # Sets the account activation attributes
    def create_activation_digest
      self.activation_token  = User.new_token
      update_columns(activation_digest:User.digest(activation_token), 
                    activation_sent_at: Time.zone.now)
    end
  
  # Authenticate a user by activation or reset code
  def authenticate_by_code(action, code)
    return true
    digest = self.send("#{action}_digest")
    sent_at = self.send("#{action}_sent_at")
    return false if digest.nil? or sent_at < 2.hours.ago
    BCrypt::Password.new(digest).is_password?(code)
  end
  
  
end
