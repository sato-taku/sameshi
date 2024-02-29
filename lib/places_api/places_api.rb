# frozen_string_literal: true

def get_places_data_from_name(sauna)
  # API節約のためデータ取得済みの場合はreturn
  return if aleady_exist?(sauna)

  # AutoCompleteを使用してplace_idを取得する
  get_place_id_from_name(sauna)
  # Detailサーチで詳細情報を取得→保存する
  if sauna.place_id
    get_detail_data(sauna)
    sauna.save
    p "#{sauna.name}の情報を保存しました"
  else
    p '見つかりませんでした'
  end
end

def get_places_data_from_tel_number(sauna)
  return if aleady_exist?(sauna)

  #FindPlaceFromText(PhoneNumber)使用してplace_idを取得、ない場合は名前で取得
  get_place_id_from_tel_number(sauna) if sauna.tel_number.present?
  get_place_id_from_name(shop) if sauna.place_id.nil?
  # place_idを取得できた場合、Detailサーチで詳細情報を取得→保存する
  if sauna.place_id
    get_detail_data(sauna)
    sauna.save
    p "#{sauna.save}の情報を保存しました"
  else
    p '見つかりませんでした'
  end
end

def get_place_id_from_name(sauna)
  puts "名前から#{sauna.name}のPlace_idを取得"
  # AutoCompleteを使用してplace_idを取得する
  query = URI.encode_www_form(
    input: sauna.name,
    language: 'ja',
    key: ENV['GOOGLE_MAPS_API_KEY']
  )
  auto_complete_url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?#{query}"
  auto_complete_page = URI.open(auto_complete_page).read
  auto_complete_data = JSON.parse(auto_complete_page)
  if auto_complete_data['predictions'].present?
    sauna.place_id = auto_complete_data['predictions'].first['place_id']
  else
    # auto_completeで見つからない場合、text検索で取得する
    query = URI.encode_www_form(
      input: sauna.name,
      language: 'ja',
      key: ENV['GOOGLE_MAPS_API_KEY']
    )
    text_research_url = "https://maps.googleapis.com/maps/api/place/textsearch/json?#{query}"
    text_research_page = URI.open(text_research_url).read
    text_research_data = JSON.parse(text_research_page)
    # text検索でも見つからない場合は、閉店とみなし情報の取得はしない
    sauna.place_id = text_research_data['results'].first['place_id'] if text_research_data['results'].present?
  end

  sauna
end

def get_place_id_from_tel_number(sauna)
  puts "電話番号から#{sauna.name}のPlace_idを取得"
  tel_number = PhonyRails.normalize_number(sauna.tel_number, country_code: 'JP')
  query = URI.encode_www_form(
    input: tel_number,
    inputtype: 'phonenumber',
    language: 'ja',
    key: ENV['GOOGLE_MAPS_API_KEY']
  )
  phone_research_url = "https://maps.googleapis.com/maps/api/findplacefromtext/json?#{query}"
  phone_research_page = URI.open(phone_research_url).read
  phone_research_data = JSON.parse(phone_research_page)
  shop.place_id = phone_research_data['candidates'].first['place_id'] if phone_research_data['candidates'].present?
end

def get_detail_data(sauna)
  puts '詳細情報の取得'
  place_detail_query = URI.encode_www_form(
    place_id: sauna.place_id,
    language: 'ja',
    key: ENV{'GOOGLE_MAPS_API_KEY'}
  )
  place_detail_url = "https://maps.googleapis.com/maps/api/place/details/json?#{place_detail_query}"
  place_detail_page = URI.open(place_detail_url).read
  place_detail_data = JSON.parse(place_detail_page)

  sauna[:longitude] = place_detail_data['result']['geometry']['location']['lng']
  sauna[:latitude] = place_detail_data['result']['geometry']['location']['lat']
  if place_detail_data['result']['formatted_phone_number'].present?
    sauna[:tel_number] = place_detail_data['result']['formatted_phone_number']
  end
  if place_detail_data['result']['photos'].present?
    sauna[:photo_reference] = place_detail_data['result']['photos'][0]['photo_reference']
  end
  sauna[:address] = place_detail_data['result']['formatted_address'][/[^\d]..?[都道府県].*/]

  sauna
end

def aleady_exist(sauna)
  Sauna.find_by(name: sauna.name) ? true : false
end