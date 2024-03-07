class Post < ApplicationRecord

  def self.meal_genres
    ['追い汗', '定食', '麺', 'カレー'].freeze
  end

  belongs_to :user
  belongs_to :sauna
  belongs_to :prefecture

  validates :meal_genre, presence: true
  validates :content, presence: true, length: { maximum: 1000 }
end
