class User < ApplicationRecord
  authenticates_with_sorcery!

  def self.age_groups
    ['10代', '20代', '30代', '40代', '50代', '60代以上'].freeze
  end

  belongs_to :prefecture
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :password, length: { minimum:4 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true, presence: true
  validates :nickname, length: { maximum: 20 }, presence: true
  validates :prefecture_id, presence: true
  validates :age_group, inclusion: { in: User.age_groups }
end
