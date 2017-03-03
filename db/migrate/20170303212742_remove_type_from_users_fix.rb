class RemoveTypeFromUsersFix < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :user_type, :string
    remove_column :users, :type, :string
  end
end
