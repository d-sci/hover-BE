class Trip < ApplicationRecord
  has_many :pools
  has_many :users, through: :pools
  
  def active_users
    users.where('pools.is_active': true)
  end
end
