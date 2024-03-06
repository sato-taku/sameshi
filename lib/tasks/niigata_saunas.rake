namespace :niigata do
  desc 'サウナ施設情報の取得と保存'
  task get_saunas: :environment do
    client = GooglePlaces::Client.new(ENV["GOOGLE_MAPS_API_KEY"])
    # 検索する都道府県の代的な地点
    points = ["新潟市中央区", "新潟市西区", "新潟市東区", "新潟市江南区", "新潟市北区", "新潟市秋葉区", "新潟市南区", "新潟市西蒲区", "阿賀野市", "阿賀町", "糸魚川市", "魚沼市", "小千谷市", "柏崎市", "加茂市", "五泉市", "三条市", "長岡市", "新発田市", "佐渡市", "上越市", "関川村", "聖籠町", "胎内市", "田上町", "津南町", "燕市", "十日町市", "見附市", "南魚沼市", "妙高市", "村上市", "弥彦村", "湯沢町"]
    # 各地点から検索を行い、結果をDBに保存
    points.each do |point|
      # サウナ施設を検索するクエリ
      query = "サウナ 新潟県#{point}"

      saunas = client.spots_by_query(query, exclude: 'pet_store', language: 'ja')
      filtered_saunas = saunas.reject do |sauna|
        # フィルタリングの条件
        sauna.name.include?('会社') || sauna.name.include?('休憩') || sauna.name.include?('エステ') || sauna.name.include?('（有）') || sauna.name.include?('福祉') || sauna.name.include?('商会') || sauna.name.include?('（株）') || sauna.name.include?('食堂')
      end
      filtered_saunas.each do |sauna|
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
