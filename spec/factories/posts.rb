FactoryBot.define do
  factory :post do
    meal_genre { Post.meal_genres.sample }
    sequence(:content) { |n| "概要#{n}" }
    association :user
    association :prefecture
    association :sauna
  end
end