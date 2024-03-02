namespace :kanagawa do
  desc 'サウナ施設情報の取得と保存'
  task get_saunas: :environment do
    client = GooglePlaces::Client.new(ENV["GOOGLE_MAPS_API_KEY"])
    # 検索する都道府県の代的な地点
    points = ["横浜市鶴見区", "横浜市神奈川区", "横浜市西区", "横浜市中区", "横浜市南区", "横浜市港南区", "横浜市保土ヶ谷区", "横浜市旭区", "横浜市磯子区", "横浜市金沢区", "横浜市港北区", "横浜市緑区", "横浜市青葉区", "横浜市都筑区", "横浜市戸塚区", "横浜市栄区", "横浜市泉区", "横浜市瀬谷区", "川崎市川崎区", "川崎市幸区", "川崎市中原区", "川崎市高津区", "川崎市多摩区", "川崎市宮前区", "川崎市麻生区", "相模原市緑区", "相模原市中央区", "相模原市南区", "横須賀市", "平塚市", "鎌倉市", "藤沢市", "小田原市", "茅ヶ崎市", "逗子市", "三浦市", "秦野市", "厚木市", "大和市", "伊勢原市", "海老名市", "座間市", "南足柄市", "綾瀬市", "葉山町", "寒川町", "大磯町", "二宮町", "中井町", "大井町", "松田町", "山北町", "開成町", "箱根町" "真鶴町", "湯河原町", "愛川町", "清川村"]
    # 各地点から検索を行い、結果をDBに保存
    points.each do |point|
      # サウナ施設を検索するクエリ
      query = "サウナ OR 銭湯 OR 温泉 神奈川県#{point}"

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