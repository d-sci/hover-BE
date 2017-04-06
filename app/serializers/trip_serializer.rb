class TripSerializer < ActiveModel::Serializer
  attributes :id, :waypoints, :waytimes, :to_work, :driver_id, :order, :confirmed, :base_trips
  
  def waytimes
    object.waytimes.map{|t| t.strftime("%l:%M %P")}
  end
  
  def waypoints
    waypoints = []
    object.waypoints.each do |p|
      waypoints << [p.y, p.x]
    end
    return waypoints
  end
  
end
