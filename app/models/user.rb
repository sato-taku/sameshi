class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader
  
  def self.age_groups
    ['10代', '20代', '30代', '40代', '50代', '60代以上'].freeze
  end

  belongs_to :prefecture
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :sent_notifications, class_name: 'Notification', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_notifications, class_name: 'Notification', foreign_key: 'recipient_id', dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  enum role: { general: 0, admin: 1 }

  validates :password, length: { minimum:4 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, uniqueness: true, allow_nil: true

  validates :email, uniqueness: true, presence: true
  validates :nickname, length: { maximum: 20 }, presence: true
  validates :prefecture_id, presence: true
  validates :age_group, inclusion: { in: User.age_groups }
  validates_acceptance_of :agreement, allow_nil: false, on: :create

  def own?(object)
    id == object&.user_id
  end

  def like(post)
    like_posts << post
  end

  def unlike(post)
    like_posts.destroy(post)
  end

  def like?(post)
    like_posts.include?(post)
  end

  def find_similar_users
    liked_post_ids = self.likes.pluck(:post_id)
    similar_user_ids = Like.where(post_id: liked_post_ids)
                           .where.not(user_id: self.id)
                           .select(:user_id).distinct
    User.where(id: similar_user_ids)
  end

  def recommend_posts
    liked_post_ids = self.likes.pluck(:post_id)
    similar_users = find_similar_users
    similar_user_post_ids = Like.where(user_id: similar_users.ids)
                                .where.not(post_id: liked_post_ids)
                                .select(:post_id).distinct
    Post.where(id: similar_user_post_ids).where.not(user_id: self.id).limit(3)
  end
end
