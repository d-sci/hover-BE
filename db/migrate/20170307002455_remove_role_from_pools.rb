class RemoveRoleFromPools < ActiveRecord::Migration[5.0]
  def change
    remove_column :pools, :role, :string
    add_column :pools, :is_driver, :boolean
    remove_column :pools, :is_deleted, :boolean
  end
end
