class AddConfirmationToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :order, :integer, array: true, default: []
    add_column :trips, :confirmed, :boolean, array: true, default: []
    add_column :trips, :base_trips, :integer, array: true, default: []
    add_column :pools, :is_pending, :boolean
    add_index :pools, [:user_id, :trip_id]
    add_column :requests, :status, :string, default: "pending"
  end
end
