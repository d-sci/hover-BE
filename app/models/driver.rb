class Driver < User
  has_many :trips, dependent: :destroy
  has_many :passengers, through: :trips
end
