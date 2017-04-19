class TripSerializer < ActiveModel::Serializer
  attributes :id, :waypoints, :waytimes, :to_work, :driver_id, :order, :confirmed, :base_trips, :users
  
  def users #this is actually only active_users
    ActiveModelSerializers::SerializableResource.new(object.active_users, each_serializer: UserSerializer, scope: scope)
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
