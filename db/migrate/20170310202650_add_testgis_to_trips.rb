class AddTestgisToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :testgis, :st_point, srid: 4326
  end
end
