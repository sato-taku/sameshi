require 'csv'
require 'open-uri'
API_KEY = ENV["GOOGLE_MAPS_APi_KEY"]

namespace :Tokyo do
  desc 'サウナ情報の取得と保存'
  task :get_saunas => :environment do
    # 電話番号からplace_idを取得するメソッド
    def get_place_id(detail)
      client = GooglePlaces::Client.new(ENV["GOOGLE_MAPS_API_KEY"])
      # 電話番号が存在する場合、電話番号で検索
      if detail['電話番号'].present?
        spot = client.spots_by_query(detail['電話番号']).first
      # 電話番号が存在しない場合、サウナ名で検索
      else
        spot = client.spots_by_query(detail['サウナ']).first
      end
      spot.place_id if spot
    end

    # place_idから詳細情報を取得するメソッド
    def get_detail_data(sauna)
      place_id = get_place_id(sauna)

      if place_id
        # クエリパラメータの作成
        place_detail_query = URI.encode_www_form(
          place_id: place_id,
          language: 'ja',
          key: ENV["GOOGLE_MAPS_API_KEY"]
        )
        # Places APIのエンドポイントの作成
        place_detail_url = "https://maps.googleapis.com/maps/api/place/details/json?#{place_detail_query}"
        # APIから取得したデータをテキストデータ(JSON形式)で取得し変数に格納
        place_detail_page = URI.open(place_detail_url).read
        # JSON形式のデータをRubyオブジェクトに変換
        place_detail_data = JSON.parse(place_detail_page)

        #取得したデータを保存するカラム名と同じキー名で、ハッシュ（result）に保存
        result = {}
        result[:name] = sauna['サウナ']

        full_address = place_detail_data['result']['formatted_address']
        result[:address] = full_address.sub(/\A[^ ]+/, '')

        result[:photo_reference] = place_detail_data['result']['photos'][0]['photo_reference'] if place_detail_data['result']['photos'].present?

        result[:tel_number] = place_detail_data['result']['formatted_phone_number']
        result[:opening_hours] = place_detail_data['result']['opening_hours']['weekday_text'].join("\n") if place_detail_data['result']['opening_hours'].present?
        result[:website] = place_detail_data['result']['website']
        result[:latitude] = place_detail_data['result']['geometry']['location']['lat']
        result[:longitude] = place_detail_data['result']['geometry']['location']['lng']
        result[:place_id] = place_id

        result
      else
        puts "詳細情報が見つかりませんでした。"
        nil
      end
    end

    #csvファイルを読み込む
    csv_file = 'lib/csv/tokyo.csv'
    #csvファイルの繰り返し処理で実行しデータベースへ保存
    CSV.foreach(csv_file, headers: true) do |row|
      sauna_data = get_detail_data(row)
      if sauna_data
        sauna = Sauna.find_or_initialize_by(place_id: sauna_data[:place_id])
        sauna.update!(sauna_data)

        puts "#{row['サウナ']}を保存しました"
        puts "----------"
      else
        puts "#{row['サウナ']}の保存に失敗しました"
        puts "----------"
      end
    end
  end
end