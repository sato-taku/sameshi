FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "本文#{n}" }
    association :user
    association :post
  end
end
