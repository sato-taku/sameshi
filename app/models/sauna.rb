class Sauna < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end

  scope :search_by_name, ->(query) { where('name LIKE ?', "%#{query}%") }
  
  has_many :posts
end
