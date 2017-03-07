class PoolSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :trip_id, :is_driver, :is_active
end
