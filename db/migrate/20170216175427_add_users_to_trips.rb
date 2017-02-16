class AddUsersToTrips < ActiveRecord::Migration[5.0]
  def change
    add_reference :trips, :driver
    add_reference :trips, :passenger
  end
end
