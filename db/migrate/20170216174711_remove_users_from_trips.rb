class RemoveUsersFromTrips < ActiveRecord::Migration[5.0]
  def change
    remove_column :trips, :driver_id, :string
    remove_column :trips, :passenger_id, :string
  end
end
