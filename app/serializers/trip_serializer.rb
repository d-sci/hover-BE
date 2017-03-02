class TripSerializer < ActiveModel::Serializer
  attributes :id, :driver_id, :passenger_id
end
