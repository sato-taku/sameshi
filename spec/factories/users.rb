FactoryBot.define do
  factory :user do
    nickname { "サ飯太郎" }
    sequence(:email) { "sameshi@example.com" }
