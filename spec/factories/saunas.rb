FactoryBot.define do
  factory :sauna do
    name { "サウナsample" }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    address { Faker::Address.full_address }
    place_id { Faker::Alphanumeric.alpha(number: 27) }
    photo_reference { Faker::Alphanumeric.alpha(number: 160) }
    tel_number { Faker::PhoneNumber.phone_number_with_country_code }
    website { Faker::Internet.url }
    opening_hours { "Mo - Su 10:00 - 20:00" }
  end
end