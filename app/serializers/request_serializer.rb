class RequestSerializer < ActiveModel::Serializer
  attributes :id, :from_user_id, :to_user_id, :from_trip_id, :to_trip_id, :status
end
