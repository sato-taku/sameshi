namespace :saitama do
  desc 'サウナ施設情報の取得と保存'
  task get_saunas: :environment do
    client = GooglePlaces::Client.new(ENV["GOOGLE_MAPS_API_KEY"])
    # 検索する都道府県の代的な地点
    points = ["さいたま市北区", "さいたま市西区", "さいたま市見沼区", "さいたま市大宮区", "さいたま市中央区", "さいたま市桜区", "さいたま市浦和区", "さいたま市南区", "さいたま市緑区", "上尾市", "朝霞市", "伊那市", "入間市", "小鹿野町", "小川町", "桶川市", "越生町", "春日部市", "加須市", "神川町", "上里町", "川口市", "川越市", "川島町", "北本市", "行田市", "久喜市", "熊谷市", "鴻巣市", "越谷市", "坂戸市", "幸手市", "狭山市", "志木市", "白岡町", "杉戸町", "草加市", "秩父市", "鶴ヶ島市", "ときがわ町", "所沢市", "戸田市", "長瀞町", "滑川町", "新座市", "蓮田市", "鳩山町", "羽生市", "飯能市", "東秩父村", "東松山市", "日高市", "深谷市", "富士見市" "ふじみ野市", "本庄市", "松伏町", "三郷市", "美里町", "皆野町", "宮代町", "三芳町", "毛呂山町", "八潮市", "横瀬町", "吉川町", "吉見町", "寄居町", "嵐山町", "和光市", "蕨市"]
    # 各地点から検索を行い、結果をDBに保存
    points.each do |point|
      # サウナ施設を検索するクエリ
      query = "サウナ OR 銭湯 OR 温泉 埼玉県#{point}"

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
