class Passenger < User
  has_many :trips, dependent: :destroy
  has_many :drivers, through: :trips
end
