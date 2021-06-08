class CreateShortenedUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :shortened_urls do |t|
      t.text :url, null: false
      t.string :unique_key, limit: 10, null: false, length: 2083
      t.integer :use_count, null: false, default: 0

      t.timestamps
    end

    add_index :shortened_urls, :unique_key, unique: true
    add_index :shortened_urls, :url, length: 2083
  end
end
