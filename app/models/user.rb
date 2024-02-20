class User < ApplicationRecord
  has_many :posts
  belongs_to :prefecture
  has_many :likes
end
