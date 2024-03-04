namespace :tokyo do
  desc 'サウナ施設情報の取得と保存'
  task get_saunas: :environment do
    client = GooglePlaces::Client.new(ENV["GOOGLE_MAPS_API_KEY"])
    # 検索する都道府県の代的な地点
    points = ["千代田区", "中央区", "港区", "新宿区", "文京区", "台東区", "墨田区", "江東区", "品川区", "目黒区", "大田区", "世田谷区", "渋谷区", "中野区", "杉並区", "豊島区", "北区", "荒川区", "板橋区", "練馬区", "足立区", "葛飾区", "江戸川区", "八王子市", "立川市", "武蔵野市", "三鷹市", "青梅市", "府中市", "昭島市", "調布市", "町田市", "小金井市", "小平市", "日野市", "東村山市", "国分寺市", "国立市", "福生市", "狛江市", "東大和市", "清瀬市", "東久留米市", "武蔵村山市", "多摩市", "稲城市", "羽村市", "あきる野市", "西東京市", "瑞穂町", "日の出町", "檜原村", "奥多摩町", "大島町"]
    # 各地点から検索を行い、結果をDBに保存
    points.each do |point|
      # サウナ施設を検索するクエリ
      query = "サウナ 東京都#{point}"

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