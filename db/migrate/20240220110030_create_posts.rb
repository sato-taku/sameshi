class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sauna, null: false, foreign_key: true
      t.references :prefecture, null: false, foreign_key: true
      t.string :meal_genre
      t.text :content
      t.string :post_image

      t.timestamps
    end
  end
end
