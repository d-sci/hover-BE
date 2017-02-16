class Trip < ApplicationRecord
  belongs_to :driver #, class_name: 'User'
  belongs_to :passenger #, class_name: 'User'
end
