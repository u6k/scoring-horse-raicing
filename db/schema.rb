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

ActiveRecord::Schema.define(version: 2019_04_29_125413) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
  end

  create_table "race_refunds", force: :cascade do |t|
    t.string "race_id"
    t.string "type"
    t.string "horse_numbers"
    t.integer "money"
  end

  create_table "race_scores", force: :cascade do |t|
    t.string "race_id"
    t.integer "rank"
    t.integer "bracket_number"
    t.integer "horse_number"
    t.float "time"
  end

end
