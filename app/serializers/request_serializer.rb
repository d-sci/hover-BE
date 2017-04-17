class RequestSerializer < ActiveModel::Serializer
  #attributes :id, :from_user_id, :to_user_id, :from_trip_id, :to_trip_id, :status
  
  
  #rewrite for full info? NB: could seperate 'in' and 'out', probably know about self anyway
  attributes :id, :from_user, :to_user, :from_trip, :to_trip, :status,  :compat
  
  def from_user
    UserSerializer.new(User.find(object.from_user_id))
  end
  
  def to_user
    UserSerializer.new(User.find(object.to_user_id))
  end
  
  def from_trip
    TripSerializer.new(Trip.find(object.from_trip_id))
  end
  
  def to_trip
    TripSerializer.new(Trip.find(object.to_trip_id))
  end
  
  def compat
    User.find(object.from_user_id).compatibility(User.find(object.to_user_id))
  end
  
end
