namespace :chiba do
  desc 'サウナ施設情報の取得と保存'
  task get_saunas: :environment do
    client = GooglePlaces::Client.new(ENV["GOOGLE_MAPS_API_KEY"])
    # 検索する都道府県の代的な地点
    points = ["千葉市中央区", "千葉市花見川区", "千葉市稲毛区", "千葉市若葉区", "千葉市緑区", "千葉市美浜区", "銚子市", "市川市", "船橋市", "館山市", "木更津市", "松戸市", "野田市", "茂原市", "成田市", "佐倉市", "東金市", "旭市", "習志野市", "柏市", "勝浦市", "市原市", "流山市", "八千代市", "我孫子市", "鴨川市", "鎌ヶ谷市", "君津市", "富津市", "浦安市", "四街道市", "袖ヶ浦市", "八街市", "印西市", "白井市", "富里市", "南房総市", "匝瑳市", "香取市", "山武市", "いすみ市", "大網白里市", "酒々井町", "栄町", "神崎町", "多古町", "東庄町", "九十九里町", "柴山町", "横芝光町", "一宮町", "睦沢町", "長生村", "白子町" "長柄町", "長南町", "大多喜町", "御宿町", "鋸南町"]
    # 各地点から検索を行い、結果をDBに保存
    points.each do |point|
      # サウナ施設を検索するクエリ
      query = "サウナ 千葉県#{point}"

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