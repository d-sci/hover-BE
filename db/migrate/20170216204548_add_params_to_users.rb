class AddParamsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :office_lat, :decimal
    add_column :users, :office_lon, :decimal
    add_column :users, :home_lat, :decimal
    add_column :users, :home_lon, :decimal
    add_column :users, :radio_stations, :string, array: true, default: []
    add_column :users, :talkativeness, :integer
    add_column :users, :smoke, :boolean
    add_column :users, :ac, :boolean
    add_column :users, :times, :json
  end
end
