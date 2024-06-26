class Link < ApplicationRecord
  acts_as_paranoid
  UNIQUE_KEY_LENGTH = 6

  before_validation :generate_unique_key, on: :create

  validates :unique_key, uniqueness: true
  validates :url, :unique_key, presence: true

  belongs_to :user
  has_many :clicks, foreign_key: 'link_id', primary_key: :unique_key, dependent: :nullify

  def to_param
    unique_key
  end

  private

  def generate_unique_key
    url = self.url

    self.unique_key ||= loop do
      hash_candidate = unique_key_candidate(url)
      break hash_candidate unless self.class.exists?(unique_key: hash_candidate)

      url += '1'
    end
  end

  def unique_key_candidate(url)
    Digest::MD5.hexdigest(url).first(UNIQUE_KEY_LENGTH)
  end
end
