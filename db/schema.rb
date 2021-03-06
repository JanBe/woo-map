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

ActiveRecord::Schema.define(version: 20161017202623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.integer  "spot_id"
    t.integer  "likes"
    t.integer  "comments"
    t.datetime "posted_at"
    t.datetime "finished_at"
    t.string   "title"
    t.string   "user_woo_id"
    t.string   "spot_woo_id"
    t.string   "picture_url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "spots", force: :cascade do |t|
    t.string   "woo_id"
    t.string   "name"
    t.decimal  "location_lat"
    t.decimal  "location_lng"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "woo_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "profile_picture_url"
    t.string   "cover_picture_url"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "woo_app_api_tokens", force: :cascade do |t|
    t.string   "access_token"
    t.datetime "expires_at"
    t.string   "scope"
    t.string   "refresh_token"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
