class TripSerializer < ActiveModel::Serializer
  attributes :id, :waypoints, :waytimes, :to_work, :confirmed
end
