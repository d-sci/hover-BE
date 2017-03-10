class ConvertPointsToPostgis < ActiveRecord::Migration[5.0]
  def change
    remove_column :trips, :testgis, :st_point, srid: 4326, array: true, default: []
    remove_column :trips, :waypoints, :json, array: true, default: []
    add_column :trips, :waypoints, :multi_point, srid: 4326
  end
end
