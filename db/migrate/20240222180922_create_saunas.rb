class CreateSaunas < ActiveRecord::Migration[7.1]
  def change
    create_table :saunas do |t|
      t.string :name, null: false
      t.decimal :latitude, precision: 10, scale: 7, null: false
      t.decimal :longitude, precision: 10, scale: 7, null: false
      t.string :address
      t.string :place_id, null: false
      t.string :photo_reference

      t.timestamps
    end
  end
end
