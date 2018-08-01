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

ActiveRecord::Schema.define(version: 2018_08_01_023110) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "race_list_pages", force: :cascade do |t|
    t.string "url"
    t.datetime "date"
    t.string "course_name"
    t.bigint "schedule_page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_page_id"], name: "index_race_list_pages_on_schedule_page_id"
  end

  create_table "result_pages", force: :cascade do |t|
    t.string "url"
    t.integer "race_number"
    t.datetime "start_datetime"
    t.string "race_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedule_pages", force: :cascade do |t|
    t.string "url"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "race_list_pages", "schedule_pages"
end
