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

ActiveRecord::Schema.define(version: 20160917210250) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pictures", force: :cascade do |t|
    t.string   "picture_type"
    t.string   "url"
    t.integer  "session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "woo_id"
    t.float    "max_airtime"
    t.float    "highest_jump"
    t.float    "total_height"
    t.float    "total_airtime"
    t.integer  "duration"
    t.integer  "number_of_jumps"
    t.string   "description"
    t.float    "max_crash_power"
    t.string   "user_name"
    t.integer  "spot_id"
    t.integer  "likes"
    t.integer  "comments"
    t.datetime "posted_at"
    t.datetime "finished_at"
    t.string   "title"
    t.string   "spot_woo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spots", force: :cascade do |t|
    t.string   "woo_id"
    t.string   "name"
    t.decimal  "location_lat", precision: 10, scale: 6
    t.decimal  "location_lng", precision: 10, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
