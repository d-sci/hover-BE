class PoolSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :trip_id, :is_active, :is_pending
end
