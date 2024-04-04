class Post < ApplicationRecord
  mount_uploader :post_image, PostImageUploader
  def self.meal_genres
    ['追い汗', '定食', '麺', 'カレー'].freeze
  end

  def self.ransackable_attributes(auth_object = nil)
    ['content', 'meal_genre', 'prefecture_id', 'sauna_id']
  end

  def self.ransackable_associations(auth_object = nil)
    ['sauna', 'prefecture']
  end

  belongs_to :user, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :sauna
  belongs_to :prefecture
  has_many :likes, dependent: :destroy

  validates :meal_genre, presence: true
  validates :sauna_id, presence: true
  validates :content, presence: true, length: { maximum: 1000 }
end
