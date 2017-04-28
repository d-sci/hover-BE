class TripSerializer < ActiveModel::Serializer
  attributes :id, :waypoints, :waytimes, :to_work, :driver_id, :order, :confirmed, :base_trips, :users
  
  # May need to change later to include only active (or pending?) users, forget it for now.
  def users 
    ActiveModelSerializers::SerializableResource.new(object.users, each_serializer: UserSerializer, scope: scope)
  end
  
  def waytimes
    object.waytimes.map{|t| t.strftime("%l:%M %P").strip}
  end
  
  def waypoints
    waypoints = []
    object.waypoints.each do |p|
      waypoints << {:lon => p.x, :lat => p.y}
    end
    return waypoints
  end
  
end
