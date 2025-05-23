class Movie < ApplicationRecord
  validates :title, presence: true
  validates :title, uniqueness: true
  validates :overview, presence:true
  has_many :bookmarks
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
end
