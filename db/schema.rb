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

ActiveRecord::Schema.define(version: 20170303213754) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pools", force: :cascade do |t|
    t.string   "role"
    t.boolean  "is_active"
    t.boolean  "is_deleted"
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_pools_on_trip_id", using: :btree
    t.index ["user_id"], name: "index_pools_on_user_id", using: :btree
  end

  create_table "trips", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "phone"
    t.string   "gender"
    t.string   "company"
    t.string   "position"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "first_name"
    t.string   "last_name"
    t.decimal  "office_lat"
    t.decimal  "office_lon"
    t.decimal  "home_lat"
    t.decimal  "home_lon"
    t.string   "radio_stations",  default: [],              array: true
    t.integer  "talkativeness"
    t.boolean  "smoke"
    t.boolean  "ac"
    t.json     "times"
    t.string   "password_digest"
    t.json     "car"
    t.string   "user_type"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "pools", "trips"
  add_foreign_key "pools", "users"
end
