FactoryBot.define do
  factory :user do
    nickname { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { '12345678' }
    password_confirmation { '12345678' }
    age_group { User.age_groups.sample }
    association :prefecture
  end
end
