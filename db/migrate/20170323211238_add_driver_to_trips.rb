class AddDriverToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :driver_id, :integer
    remove_column :pools, :is_driver, :boolean
  end
end
