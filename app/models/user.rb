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
  
  # Confirm the specified trip
  def confirm_trip(trip)
    i = trip.order.index(id)
    temp = trip.confirmed
    temp[i] = true
    trip.update_columns(confirmed: temp)
  end
  
  # Return your matches (trips plus basic user info) for your specified trip
  def matches(trip)
    if trip.to_work
      origin_dist = 8000
      destination_dist = 1000
    else
      origin_dist = 1000
      destination_dist = 8000
    end
  
    sql = "select * from trips t join pools p on p.trip_id = t.id join users u on p.user_id = u.id
        where p.is_active = true and u.id != :uid and
            (u.driving_pref = 0 or u.driving_pref != :driving_pref) and t.to_work = :to_work and 
            ST_NumGeometries(t.waypoints) = 2 and
            ST_DWithin( ST_geometryN(t.waypoints, 1)::geography , :origin::geography, :origin_dist ) and
            ST_DWithin( ST_geometryN(t.waypoints, 2)::geography , :destination::geography, :destination_dist )
            limit 20"
    vars = {
      uid: id, driving_pref: driving_pref, to_work: trip.to_work,
      origin: trip.waypoints[0], destination: trip.waypoints[1],
      origin_dist: origin_dist, destination_dist: destination_dist
      }
    
      # This gets up to 20 trips where (in order):
      # - the match user is actively taking this trip
      # - the match user isn't the current user
      # - the match user is neutral driving_pref or opposite of current user
      # - the match trip has same "to_work" value as current trip
      # - the match trip is currently an individual trip (technically not checking this, just checking that trip only has 2 waypoints)
      # - the match trip's origin is within [origin_dist] of the current trip's origin (note the difference in indexing!)
      # - the match trip's destination is [destination_dist] 1km of the current trip's destination
      
      # ATM TIMES NEVER CONSIDERED ANYWHERE
      # SHOULD FILTER IN DB BASED ON TIME/LOCATIONS (POSSIBLY ORDER AND LIMIT), THEN ALSO COMPUTE COMPAT AND ORDER RESULTS SOMEHOW
      # SHOULD HAVE SOME WAY OF RELAXING IF NOT ENOUGH RESULTS / BEING MORE PICKY IF TOO MANY.
      # ALSO SHOULD PRIORITIZE EXISTING MATCHES SOMEWHERE SOMEHOW
    
    @matched_trips = Trip.find_by_sql [sql, vars]
    @matches = []
    @matched_trips.each do |t|
      @matched_user = t.users.first
      @match = {
          trip: TripSerializer.new(t), 
          user_id: @matched_user.id, 
          user_name: @matched_user.first_name,
          user_avatar: @matched_user.avatar.url,
          compat: compatibility(@matched_user)
      }
      @matches << @match
    end
    @matches.sort_by!{|x| -x[:compat]}
    return @matches
    
  end
  
  
end
