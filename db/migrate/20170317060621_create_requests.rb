class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.integer :from_trip_id
      t.integer :to_trip_id
      t.timestamps
    end
    add_index :requests, :from_user_id
    add_index :requests, :to_user_id
    add_index :requests, [:from_user_id, :to_user_id]
  end
end
