# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_10_030035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "crawline_caches", force: :cascade do |t|
    t.string "url"
    t.string "request_method"
    t.datetime "downloaded_timestamp"
    t.string "storage_path"
  end

  create_table "crawline_headers", force: :cascade do |t|
    t.bigint "crawline_cache_id"
    t.string "message_type"
    t.string "header_name"
    t.string "header_value"
    t.index ["crawline_cache_id"], name: "index_crawline_headers_on_crawline_cache_id"
  end

  create_table "crawline_related_links", force: :cascade do |t|
    t.bigint "crawline_cache_id"
    t.string "url"
    t.index ["crawline_cache_id"], name: "index_crawline_related_links_on_crawline_cache_id"
  end

  create_table "odds_bracket_quinellas", force: :cascade do |t|
    t.bigint "race_meta_id"
    t.integer "bracket_number_1"
    t.integer "bracket_number_2"
    t.float "odds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_meta_id"], name: "index_odds_bracket_quinellas_on_race_meta_id"
  end

  create_table "odds_places", force: :cascade do |t|
    t.bigint "race_meta_id"
    t.integer "horse_number"
    t.float "odds_1"
    t.float "odds_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_meta_id"], name: "index_odds_places_on_race_meta_id"
  end

  create_table "odds_wins", force: :cascade do |t|
    t.bigint "race_meta_id"
    t.integer "horse_number"
    t.float "odds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_meta_id"], name: "index_odds_wins_on_race_meta_id"
  end

  create_table "race_entries", force: :cascade do |t|
    t.bigint "race_meta_id"
    t.integer "bracket_number"
    t.integer "horse_number"
    t.string "horse_id"
    t.string "horse_name"
    t.string "gender"
    t.integer "age"
    t.string "coat_color"
    t.string "trainer_id"
    t.string "trainer_name"
    t.integer "horse_weight"
    t.string "jockey_id"
    t.string "jockey_name"
    t.float "jockey_weight"
    t.string "father_horse_name"
    t.string "mother_horse_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_meta_id"], name: "index_race_entries_on_race_meta_id"
  end

  create_table "race_meta", force: :cascade do |t|
    t.string "race_id"
    t.integer "race_number"
    t.datetime "start_datetime"
    t.string "race_name"
    t.string "course_name"
    t.string "course_length"
    t.string "weather"
    t.string "course_condition"
    t.string "race_class"
    t.string "prize_class"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "race_refunds", force: :cascade do |t|
    t.bigint "race_meta_id"
    t.string "refund_type"
    t.string "horse_numbers"
    t.integer "money"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_meta_id"], name: "index_race_refunds_on_race_meta_id"
  end

  create_table "race_scores", force: :cascade do |t|
    t.bigint "race_meta_id"
    t.integer "rank"
    t.integer "bracket_number"
    t.integer "horse_number"
    t.float "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_meta_id"], name: "index_race_scores_on_race_meta_id"
  end

  add_foreign_key "crawline_headers", "crawline_caches", column: "crawline_cache_id"
  add_foreign_key "crawline_related_links", "crawline_caches", column: "crawline_cache_id"
  add_foreign_key "odds_bracket_quinellas", "race_meta", column: "race_meta_id"
  add_foreign_key "odds_places", "race_meta", column: "race_meta_id"
  add_foreign_key "odds_wins", "race_meta", column: "race_meta_id"
  add_foreign_key "race_entries", "race_meta", column: "race_meta_id"
  add_foreign_key "race_refunds", "race_meta", column: "race_meta_id"
  add_foreign_key "race_scores", "race_meta", column: "race_meta_id"
end
