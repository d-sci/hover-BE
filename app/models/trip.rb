class Trip < ApplicationRecord
  has_many :pools
  has_many :users, through: :pools
  
  def active_users
    users.where('pools.is_active': true)
  end
  
  def activate_pending
    confirmed.size.times do |i|
        Pool.find_by_user_id_and_trip_id(order[i], base_trips[i]).update(is_active: false)
        Pool.find_by_user_id_and_trip_id(order[i], id).update(is_active: true, is_pending: false)
      end
  end
end
