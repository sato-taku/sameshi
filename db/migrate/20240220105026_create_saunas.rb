class CreateSaunas < ActiveRecord::Migration[7.1]
  def change
    create_table :saunas do |t|
      t.string :name
      t.decimal :latitude
      t.decimal :longitude
      t.string :address
      t.string :place_id
      t.string :photo_reference

      t.timestamps
    end
  end
end
