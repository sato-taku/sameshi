class Sauna < ApplicationRecord
  geocoded_by :address
  after_validation :geocode
  has_many :posts
end
