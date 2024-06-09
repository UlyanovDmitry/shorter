class AddUserIdToLink < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :user_id, :bigint
    add_index :links, :user_id
  end
end
