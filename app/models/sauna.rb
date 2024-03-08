class Sauna < ApplicationRecord
  scope :search_by_name, ->(query) { where('name LIKE ?', "%#{query}%") }
  
  has_many :posts
end
