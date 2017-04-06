class FixDefaultWaypoints < ActiveRecord::Migration[5.0]
  def change
    change_column_null :trips, :waypoints, true
    change_column_default :trips, :waypoints, from: 'MULTIPOINT(-79.3841 43.6534, -79.3841 43.6534)', to: nil
  end
end
