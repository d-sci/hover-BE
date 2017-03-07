class AddHasAvatarToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :has_avatar, :boolean, default: false
    remove_column :trips, :waypoints, :decimal, array: true, default: []
    add_column :trips, :waypoints, :json, array: true, default: []
  end
end
