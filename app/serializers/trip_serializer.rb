class TripSerializer < ActiveModel::Serializer
  attributes :id, :waypoints, :waytimes
end
