class RemoveLogisticsFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :office_lat, :decimal
    remove_column :users, :office_lon, :decimal
    remove_column :users, :home_lat, :decimal
    remove_column :users, :home_lon, :decimal
    remove_column :users, :times, :json
    add_column :trips, :waypoints, :decimal, array: true, default: []
    add_column :trips, :waytimes, :time, array: true, default: []
    add_column :trips, :to_work, :boolean
  end
end
