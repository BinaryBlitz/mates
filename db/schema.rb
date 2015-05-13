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

ActiveRecord::Schema.define(version: 20150513142329) do

  create_table "comments", force: :cascade do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["event_id"], name: "index_comments_on_event_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "event_members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.boolean  "approved",   default: false
    t.boolean  "accepted",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "event_members", ["event_id"], name: "index_event_members_on_event_id"
  add_index "event_members", ["user_id"], name: "index_event_members_on_user_id"

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "target"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "city"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "info"
    t.string   "visibility"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "address"
    t.integer  "admin_id"
    t.string   "photo"
  end

  add_index "events", ["admin_id"], name: "index_events_on_admin_id"

  create_table "friend_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "friend_requests", ["friend_id"], name: "index_friend_requests_on_friend_id"
  add_index "friend_requests", ["user_id"], name: "index_friend_requests_on_user_id"

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id"
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id"

  create_table "invites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "invites", ["event_id"], name: "index_invites_on_event_id"
  add_index "invites", ["user_id"], name: "index_invites_on_user_id"

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "memberships", ["event_id"], name: "index_memberships_on_event_id"
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id"

  create_table "proposals", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "proposals", ["creator_id"], name: "index_proposals_on_creator_id"
  add_index "proposals", ["event_id"], name: "index_proposals_on_event_id"
  add_index "proposals", ["user_id"], name: "index_proposals_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nickname"
    t.date     "birthday"
    t.boolean  "gender"
    t.string   "api_token"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "avatar"
    t.integer  "vk_id"
    t.integer  "facebook_id",     limit: 8
    t.string   "password_digest"
    t.string   "city"
    t.string   "phone_number"
  end

end
