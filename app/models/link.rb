class Link < ApplicationRecord
  KEY_CHARS = ('a'..'z').to_a + (0..9).to_a.freeze
  UNIQUE_KEY_LENGTH = 5

  before_validation :generate_unique_key, on: :create

  validates :unique_key, uniqueness: true
  validates :url, :unique_key, presence: true

  def to_param
    unique_key
  end

  def increment_usage_count
    self.class.increment_counter(:use_count, id, touch: true)
  end

  private

  def generate_unique_key
    self.unique_key ||= loop do
      candidate = unique_key_candidate
      break candidate unless self.class.exists?(unique_key: candidate)
    end
  end

  def unique_key_candidate
    (0...UNIQUE_KEY_LENGTH).map { KEY_CHARS[rand(KEY_CHARS.size)] }.join
  end
end
