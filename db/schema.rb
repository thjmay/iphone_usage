# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140228100242) do

  create_table "events", force: true do |t|
    t.string   "name"
    t.integer  "time"
    t.string   "distinct_id"
    t.integer  "wifi"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sk_event_id"
    t.integer  "sk_ticketed_event"
  end

  add_index "events", ["sk_event_id"], name: "index_events_on_sk_event_id"
  add_index "events", ["user_id", "distinct_id", "time", "name"], name: "index_events_on_user_id_and_distinct_id_and_time_and_name"

  create_table "users", force: true do |t|
    t.string   "distinct_id"
    t.string   "sk_user_id"
    t.integer  "full_user"
    t.integer  "transactions"
    t.string   "app_version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "install_time"
  end

  add_index "users", ["distinct_id"], name: "index_users_on_distinct_id", unique: true

end
