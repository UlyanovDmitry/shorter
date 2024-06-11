class RemoveUseCountFromLinks < ActiveRecord::Migration[7.1]
  def change
    remove_column :links, :use_count, :integer
  end
end
