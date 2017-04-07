class Request < ApplicationRecord
  belongs_to :to_user, class_name: "User"
  belongs_to :from_user, class_name: "User"
  validates :to_user_id, presence: true
  validates :to_trip_id, presence: true
  validates :from_user_id, presence: true
  validates :from_trip_id, presence: true
  
  # Make (and return) a pending trip after request is accepted
  def create_pending_trip
    # choose driver based on logic. if both 0s, pick requestee.
    to_driving_pref = to_user.driving_pref
    from_driving_pref = from_user.driving_pref
    if to_driving_pref > from_driving_pref
      driver = to_user_id
    elsif to_driving_pref < from_driving_pref
      driver = from_user_id
    else
      driver = to_user_id
    end
    # points and times are d1,p1,p2,d2 (tho will require editing) 
    factory = RGeo::Cartesian.factory(:srid => 4326)
    to_points = Trip.find(to_trip_id).waypoints
    from_points = Trip.find(from_trip_id).waypoints
    to_times = Trip.find(to_trip_id).waytimes
    from_times= Trip.find(from_trip_id).waytimes
    if driver == to_user_id
      waypoints = factory.multi_point([to_points[0], from_points[0], from_points[1], to_points[1]])
      waytimes = [to_times[0], from_times[0], from_times[1], to_times[1]]
    else
      waypoints = factory.multi_point([from_points[0], to_points[0], to_points[1], from_points[1]])
      waytimes = [from_times[0], to_times[0], to_times[1], from_times[1]]
    end
    # create the trip and pools (pending, not active)
    @trip = Trip.create(
        driver_id: driver,
        waypoints: waypoints,
        waytimes: waytimes,
        to_work: Trip.find(to_trip_id).to_work,
        order: [to_user_id, from_user_id],
        confirmed: [false, false],
        base_trips:[to_trip_id, from_trip_id]
        )
    Pool.create(user_id: to_user_id, trip_id: @trip.id, is_active: false, is_pending: true)
    Pool.create(user_id: from_user_id, trip_id: @trip.id, is_active: false, is_pending: true)
    return @trip
  end
end
