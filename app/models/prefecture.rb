class Prefecture < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end
  
  has_many :users
  has_many :posts
end
