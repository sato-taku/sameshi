class Post < ApplicationRecord
  mount_uploaders :images, ImageUploader
  def self.meal_genres
    ['和食', '洋食', '中華', 'アジア', 'ラーメン', 'うどん', 'そば', 'カレー', '焼肉', '鍋', '居酒屋', 'その他'].freeze
  end

  def self.ransackable_attributes(auth_object = nil)
    ['content', 'meal_genre', 'prefecture_id', 'sauna_id']
  end

  def self.ransackable_associations(auth_object = nil)
    ['sauna', 'prefecture']
  end

  belongs_to :user
  has_many :comments, dependent: :destroy
  belongs_to :sauna
  belongs_to :prefecture
  has_many :likes, dependent: :destroy

  validates :meal_genre, presence: true
  validates :sauna_id, presence: true
  validates :content, presence: true, length: { maximum: 1000 }
end
