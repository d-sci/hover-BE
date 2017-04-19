class RequestSerializer < ActiveModel::Serializer
  attributes :id, :status, :other_trip, :my_trip
  
  def other_trip
    if scope.id == object.to_user_id
      t = Trip.find(object.from_trip_id)
    else
      t = Trip.find(object.to_trip_id)
    end
    return TripSerializer.new(t, scope: scope)
  end
  
  def my_trip
    if scope.id == object.to_user_id
      t = Trip.find(object.to_trip_id)
    else
      t = Trip.find(object.from_trip_id)
    end
    return TripSerializer.new(t, scope: scope)
  end
  
end
