class CreateClicks < ActiveRecord::Migration[7.1]
  def change
    create_table :clicks do |t|
      t.string :link_id
      t.timestamp :timestamp
      t.string :ip
      t.string :user_agent

      t.timestamps
    end

    add_index :clicks, :link_id
  end
end
