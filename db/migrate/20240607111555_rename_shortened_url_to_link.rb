class RenameShortenedUrlToLink < ActiveRecord::Migration[7.1]
  def change
    rename_table :shortened_urls, :links
  end
end
