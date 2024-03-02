namespace :shizuoka do
  desc 'サウナ施設情報の取得と保存'
  task get_saunas: :environment do
    client = GooglePlaces::Client.new(ENV["GOOGLE_MAPS_API_KEY"])
    # 検索する都道府県の代的な地点
    points = ["静岡市葵区", "静岡市駿河区", "静岡市清水区", "浜松市中央区", "浜松市浜名区", "浜松市天竜区", "沼津市", "熱海市", "三島市", "富士宮市", "伊東市", "島田市", "富士市", "磐田市", "焼津市", "掛川市", "藤枝市", "御殿場市", "袋井市", "下田市", "裾野市", "湖西市", "伊豆市", "御前崎市", "菊川市", "伊豆の国市", "牧之原氏", "東伊豆町", "河津町", "南伊豆町", "松崎町", "西伊豆町", "函南町", "清水町", "長泉町", "小山町", "吉田町", "川根本町", "森町"]
    # 各地点から検索を行い、結果をDBに保存
    points.each do |point|
      # サウナ施設を検索するクエリ
      query = "サウナ OR 銭湯 OR 温泉 静岡県#{point}"

      saunas = client.spots_by_query(query, language: 'ja')
      saunas.each do |sauna|
        new_sauna = Sauna.find_or_initialize_by(place_id: sauna.place_id)
        new_sauna.assign_attributes(
          name: sauna.name,
          address: sauna.vicinity,
          latitude: sauna.lat,
          longitude: sauna.lng,
          # Google Places APIから取得した最初の写真のphoto_reference
          photo_reference: sauna.photos.present? ? sauna.photos[0].photo_reference : nil,
          # 電話番号は別途取得する必要がある
          tel_number: nil
        )

        if new_sauna.save
          puts "#{new_sauna.name}が保存されました"
        else
          puts "#{new_sauna.name}の保存に失敗しました"
        end
      end
    end
  end
end
