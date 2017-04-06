class SetDefaults < ActiveRecord::Migration[5.0]
  def change
    # pools
    change_column_null :pools, :is_active, false, false
    change_column_default :pools, :is_active, from: nil, to: false
    change_column_null :pools, :user_id, false
    change_column_null :pools, :trip_id, false
    change_column_null :pools, :is_pending, false, false
    change_column_default :pools, :is_pending, from: nil, to: false
    # requests
    change_column_null :requests, :from_user_id, false
    change_column_null :requests, :from_trip_id, false
    change_column_null :requests, :to_user_id, false
    change_column_null :requests, :to_trip_id, false
    change_column_null :requests, :status, false
    # trips
    change_column_null :trips, :waytimes, false
    change_column_null :trips, :waypoints, false
    change_column_default :trips, :waypoints, from: nil, to: 'MULTIPOINT(-79.3841 43.6534, -79.3841 43.6534)'
    change_column_null :trips, :to_work, false
    change_column_default :trips, :to_work, from: nil, to: true
    change_column_null :trips, :order, false
    change_column_null :trips, :confirmed, false
    change_column_null :trips, :base_trips, false
    change_column_null :trips, :driver_id, false, 0
    change_column_default :trips, :driver_id, from: nil, to: 0
    # users
    change_column_null :users, :email, false , ''
    change_column_default :users, :email, from: nil, to: ''
    change_column_null :users, :phone, false, ''
    change_column_default :users, :phone, from: nil, to: ''
    change_column_null :users, :gender, false, ''
    change_column_default :users, :gender, from: nil, to: ''
    change_column_null :users, :company, false, ''
    change_column_default :users, :company, from: nil, to: ''
    change_column_null :users, :position, false, ''
    change_column_default :users, :position, from: nil, to: ''
    change_column_null :users, :first_name, false, ''
    change_column_default :users, :first_name, from: nil, to: ''
    change_column_null :users, :last_name, false, ''
    change_column_default :users, :last_name, from: nil, to: ''
    change_column_null :users, :radio_stations, false
    change_column_null :users, :talkativeness, false, 5
    change_column_default :users, :talkativeness, from: nil, to: 5
    change_column_null :users, :smoke, false, false
    change_column_default :users, :smoke, from: nil, to: false
    change_column_null :users, :ac, false, true
    change_column_default :users, :ac, from: nil, to: true
    change_column_null :users, :car, false, {}
    change_column_default :users, :car, from: nil, to: {}
    change_column_null :users, :activated, false
    change_column_null :users, :driving_pref, false, 0
    change_column_default :users, :driving_pref, from: nil, to: 0
    
  end
end
