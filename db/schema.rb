# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_02_22_183047) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "sauna_id", null: false
    t.bigint "prefecture_id", null: false
    t.string "meal_genre", null: false
    t.text "content", null: false
    t.string "post_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prefecture_id"], name: "index_posts_on_prefecture_id"
    t.index ["sauna_id"], name: "index_posts_on_sauna_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "prefectures", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saunas", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "latitude", precision: 10, scale: 7, null: false
    t.decimal "longitude", precision: 10, scale: 7, null: false
    t.string "address"
    t.string "place_id", null: false
    t.string "photo_reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "nickname"
    t.string "email", null: false
    t.bigint "prefecture_id"
    t.string "age_group"
    t.string "avatar"
    t.string "crypted_password"
    t.string "salt"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["prefecture_id"], name: "index_users_on_prefecture_id"
  end

  add_foreign_key "posts", "prefectures"
  add_foreign_key "posts", "saunas"
  add_foreign_key "posts", "users"
  add_foreign_key "users", "prefectures"
end
