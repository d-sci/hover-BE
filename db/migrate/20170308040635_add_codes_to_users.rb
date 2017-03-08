class AddCodesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :reset_sent_at, :datetime
    add_column :users, :reset_digest, :string
    add_column :users, :activation_sent_at, :datetime
    add_column :users, :activation_digest, :string
    add_column :users, :activated, :boolean, default: false
    add_column :users, :activated_at, :datetime
    add_column :users, :driving_pref, :integer
  end
end
