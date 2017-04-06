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

ActiveRecord::Schema.define(version: 20170406194637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "pools", force: :cascade do |t|
    t.boolean  "is_active",  default: false, null: false
    t.integer  "user_id",                    null: false
    t.integer  "trip_id",                    null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "is_pending", default: false, null: false
    t.index ["trip_id"], name: "index_pools_on_trip_id", using: :btree
    t.index ["user_id", "trip_id"], name: "index_pools_on_user_id_and_trip_id", using: :btree
    t.index ["user_id"], name: "index_pools_on_user_id", using: :btree
  end

  create_table "requests", force: :cascade do |t|
    t.integer  "from_user_id",                     null: false
    t.integer  "to_user_id",                       null: false
    t.integer  "from_trip_id",                     null: false
    t.integer  "to_trip_id",                       null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "status",       default: "pending", null: false
    t.index ["from_user_id", "to_user_id"], name: "index_requests_on_from_user_id_and_to_user_id", using: :btree
    t.index ["from_user_id"], name: "index_requests_on_from_user_id", using: :btree
    t.index ["to_user_id"], name: "index_requests_on_to_user_id", using: :btree
  end

  create_table "trips", force: :cascade do |t|
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.time     "waytimes",                                               default: [],   null: false, array: true
    t.boolean  "to_work",                                                default: true, null: false
    t.geometry "waypoints",  limit: {:srid=>4326, :type=>"multi_point"}
    t.integer  "order",                                                  default: [],   null: false, array: true
    t.boolean  "confirmed",                                              default: [],   null: false, array: true
    t.integer  "base_trips",                                             default: [],   null: false, array: true
    t.integer  "driver_id",                                              default: 0,    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",              default: "",    null: false
    t.string   "phone",              default: "",    null: false
    t.string   "gender",             default: "",    null: false
    t.string   "company",            default: "",    null: false
    t.string   "position",           default: "",    null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "first_name",         default: "",    null: false
    t.string   "last_name",          default: "",    null: false
    t.string   "radio_stations",     default: [],    null: false, array: true
    t.integer  "talkativeness",      default: 5,     null: false
    t.boolean  "smoke",              default: false, null: false
    t.boolean  "ac",                 default: true,  null: false
    t.string   "password_digest"
    t.json     "car",                default: {},    null: false
    t.datetime "reset_sent_at"
    t.string   "reset_digest"
    t.datetime "activation_sent_at"
    t.string   "activation_digest"
    t.boolean  "activated",          default: false, null: false
    t.datetime "activated_at"
    t.integer  "driving_pref",       default: 0,     null: false
    t.string   "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "pools", "trips"
  add_foreign_key "pools", "users"
end
