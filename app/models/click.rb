class Click < ApplicationRecord
  belongs_to :link, foreign_key: :link_id, primary_key: :unique_key

  def timestamp=(value)
    value = Time.at(value) if value.is_a? Integer

    super(value)
  end
end
