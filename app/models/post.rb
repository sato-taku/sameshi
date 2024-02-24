class Post < ApplicationRecord
  belongs_to :user
  belongs_to :sauna
  belongs_to :prefecture
end
