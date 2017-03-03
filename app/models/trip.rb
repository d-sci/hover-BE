class Trip < ApplicationRecord
  has_many :pools
  has_many :users, through: :pools
end
