require 'google_places'

namespace :update do
  desc 'photo_referenceを更新'
  task :photo_reference, [:start_id, :end_id] => :environment do |t, args|
    client = GooglePlaces::Client.new(ENV['GOOGLE_MAPS_API_KEY'])

    Sauna.where(id: args[:start_id].to_i..args[:end_id].to_i).find_each do |sauna|
      spot = client.spot(sauna.place_id, language: 'ja')
      if spot.photos.present?
        new_photo_reference = spot.photos.first.photo_reference
        sauna.update(photo_reference: new_photo_reference)
        puts "#{sauna.name} の写真情報を更新しました。"
      else
        puts "#{sauna.name} の写真が見つかりませんでした。"
      end
    end
  rescue StandardError => e
    puts "エラーが発生しました: #{e.message}"
  end
end

