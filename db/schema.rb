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

ActiveRecord::Schema.define(version: 20160123115413) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "respondent_id"
  end

  add_index "comments", ["event_id"], name: "index_comments_on_event_id", using: :btree
  add_index "comments", ["respondent_id"], name: "index_comments_on_respondent_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "device_tokens", force: :cascade do |t|
    t.string   "token"
    t.string   "platform"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "device_tokens", ["user_id"], name: "index_device_tokens_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "starts_at"
    t.string   "city"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "description"
    t.string   "visibility"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "address"
    t.integer  "creator_id"
    t.string   "photo"
    t.integer  "category_id"
    t.integer  "user_limit"
    t.integer  "min_age"
    t.integer  "max_age"
    t.string   "gender"
    t.string   "sharing_token"
    t.integer  "extra_category_id"
  end

  add_index "events", ["category_id"], name: "index_events_on_category_id", using: :btree
  add_index "events", ["creator_id"], name: "index_events_on_creator_id", using: :btree
  add_index "events", ["extra_category_id"], name: "index_events_on_extra_category_id", using: :btree

  create_table "feeds", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "feeds", ["user_id"], name: "index_feeds_on_user_id", using: :btree

  create_table "friend_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "accepted"
  end

  add_index "friend_requests", ["friend_id"], name: "index_friend_requests_on_friend_id", using: :btree
  add_index "friend_requests", ["user_id"], name: "index_friend_requests_on_user_id", using: :btree

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id", using: :btree
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id", using: :btree

  create_table "interests", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "interests", ["category_id"], name: "index_interests_on_category_id", using: :btree
  add_index "interests", ["user_id"], name: "index_interests_on_user_id", using: :btree

  create_table "invites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "accepted"
  end

  add_index "invites", ["event_id"], name: "index_invites_on_event_id", using: :btree
  add_index "invites", ["user_id"], name: "index_invites_on_user_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "memberships", ["event_id"], name: "index_memberships_on_event_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "photos", ["user_id"], name: "index_photos_on_user_id", using: :btree

  create_table "preferences", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "notifications_friends", default: true
    t.boolean  "notifications_events",  default: true
    t.string   "visibility_photos",     default: "public"
    t.string   "visibility_events",     default: "public"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "preferences", ["user_id"], name: "index_preferences_on_user_id", using: :btree

  create_table "proposals", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "proposals", ["creator_id"], name: "index_proposals_on_creator_id", using: :btree
  add_index "proposals", ["event_id"], name: "index_proposals_on_event_id", using: :btree
  add_index "proposals", ["user_id"], name: "index_proposals_on_user_id", using: :btree

  create_table "rpush_apps", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                                null: false
    t.string   "auth_key"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  add_index "rpush_feedback", ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound",                        default: "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                       default: 86400
    t.boolean  "delivered",                    default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                       default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "alert_is_json",                default: false
    t.string   "type",                                             null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",             default: false,     null: false
    t.text     "registration_ids"
    t.integer  "app_id",                                           null: false
    t.integer  "retries",                      default: 0
    t.string   "uri"
    t.datetime "fail_after"
    t.boolean  "processing",                   default: false,     null: false
    t.integer  "priority"
    t.text     "url_args"
    t.string   "category"
  end

  add_index "rpush_notifications", ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))", using: :btree

  create_table "searches", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.string   "visibility"
    t.datetime "min_starts_at"
    t.datetime "max_starts_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.date     "dates",                      array: true
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "distance"
    t.integer  "category_ids",               array: true
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "accepted"
  end

  add_index "submissions", ["event_id"], name: "index_submissions_on_event_id", using: :btree
  add_index "submissions", ["user_id", "event_id"], name: "index_submissions_on_user_id_and_event_id", unique: true, using: :btree
  add_index "submissions", ["user_id"], name: "index_submissions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthday"
    t.string   "gender"
    t.string   "api_token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "avatar"
    t.string   "city"
    t.string   "phone_number"
    t.datetime "visited_at"
    t.string   "avatar_original"
    t.string   "website_url"
  end

  create_table "verification_tokens", force: :cascade do |t|
    t.string   "token"
    t.string   "phone_number"
    t.integer  "code"
    t.boolean  "verified"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_foreign_key "comments", "events"
  add_foreign_key "comments", "users"
  add_foreign_key "device_tokens", "users"
  add_foreign_key "events", "categories"
  add_foreign_key "friend_requests", "users"
  add_foreign_key "friendships", "users"
  add_foreign_key "invites", "events"
  add_foreign_key "invites", "users"
  add_foreign_key "memberships", "events"
  add_foreign_key "memberships", "users"
  add_foreign_key "preferences", "users"
  add_foreign_key "proposals", "events"
  add_foreign_key "proposals", "users"
  add_foreign_key "submissions", "events"
  add_foreign_key "submissions", "users"
end
