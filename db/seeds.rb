# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
prefectures = [
  '北海道', '青森県', '岩手県', '宮城県', '秋田県', 
  '山形県', '福島県', '茨城県', '栃木県', '群馬県', 
  '埼玉県', '千葉県', '東京都', '神奈川県', '新潟県', 
  '富山県', '石川県', '福井県', '山梨県', '長野県', 
  '岐阜県', '静岡県', '愛知県', '三重県', '滋賀県', 
  '京都府', '大阪府', '兵庫県', '奈良県', '和歌山県', 
  '鳥取県', '島根県', '岡山県', '広島県', '山口県', 
  '徳島県', '香川県', '愛媛県', '高知県', '福岡県', 
  '佐賀県', '長崎県', '熊本県', '大分県', '宮崎県', 
  '鹿児島県', '沖縄県'
]

prefectures.each do |name|
  Prefecture.find_or_create_by!(name: name)
end

niigata_prefecture = Prefecture.find_by(name: '新潟県')

10.times do
  User.create!(
    nickname: Faker::Name.name,
    email: Faker::Internet.email,
    prefecture_id: niigata_prefecture.id,
    age_group: User.age_groups.sample,
    password: "password",
    password_confirmation: "password"
  )
end

10.times do
  sauna = Sauna.all.sample
  user = User.all.sample

  Post.create!(
    user_id: user.id,
    sauna_id: sauna.id,
    prefecture_id: niigata_prefecture.id,
    meal_genre: Post.meal_genres.sample,
    content: Faker::Lorem.sentence,
    post_image: nil
  )
end
