class RemoveTypeFromUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :car, :json
    remove_reference :trips, :driver
    remove_reference :trips, :passenger
  end
end
