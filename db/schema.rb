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

ActiveRecord::Schema.define(version: 20161229004441) do

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
    t.index ["event_id"], name: "index_comments_on_event_id", using: :btree
    t.index ["respondent_id"], name: "index_comments_on_respondent_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "device_tokens", force: :cascade do |t|
    t.string   "token"
    t.string   "platform"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_device_tokens_on_user_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "starts_at"
    t.string   "city"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "description"
    t.string   "visibility"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
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
    t.integer  "memberships_count", default: 0, null: false
    t.index ["category_id"], name: "index_events_on_category_id", using: :btree
    t.index ["creator_id"], name: "index_events_on_creator_id", using: :btree
    t.index ["extra_category_id"], name: "index_events_on_extra_category_id", using: :btree
  end

  create_table "friend_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "accepted"
    t.index ["friend_id"], name: "index_friend_requests_on_friend_id", using: :btree
    t.index ["user_id"], name: "index_friend_requests_on_user_id", using: :btree
  end

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id", using: :btree
    t.index ["user_id"], name: "index_friendships_on_user_id", using: :btree
  end

  create_table "interests", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_interests_on_category_id", using: :btree
    t.index ["user_id"], name: "index_interests_on_user_id", using: :btree
  end

  create_table "invites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "accepted"
    t.index ["event_id"], name: "index_invites_on_event_id", using: :btree
    t.index ["user_id"], name: "index_invites_on_user_id", using: :btree
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_memberships_on_event_id", using: :btree
    t.index ["user_id"], name: "index_memberships_on_user_id", using: :btree
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_photos_on_user_id", using: :btree
  end

  create_table "reports", force: :cascade do |t|
    t.text     "content",    null: false
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_reports_on_event_id", using: :btree
    t.index ["user_id"], name: "index_reports_on_user_id", using: :btree
  end

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
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound",                        default: "default"
    t.text     "alert"
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
    t.boolean  "content_available",            default: false
    t.text     "notification"
    t.index ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))", using: :btree
  end

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
    t.integer  "user_id"
    t.index ["user_id"], name: "index_searches_on_user_id", using: :btree
  end

  create_table "social_tokens", force: :cascade do |t|
    t.string   "service_type"
    t.integer  "social_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "accepted"
    t.index ["event_id"], name: "index_submissions_on_event_id", using: :btree
    t.index ["user_id"], name: "index_submissions_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthday"
    t.string   "gender"
    t.string   "api_token"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "avatar"
    t.string   "city"
    t.string   "phone_number"
    t.datetime "visited_at"
    t.string   "avatar_original"
    t.string   "website_url"
    t.boolean  "notifications_friends", default: true, null: false
    t.boolean  "notifications_events",  default: true, null: false
    t.integer  "vk_id"
    t.integer  "fb_id"
    t.integer  "tw_id"
  end

  create_table "verification_tokens", force: :cascade do |t|
    t.string   "token"
    t.string   "phone_number"
    t.string   "code",         null: false
    t.boolean  "verified"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["phone_number"], name: "index_verification_tokens_on_phone_number", using: :btree
    t.index ["token"], name: "index_verification_tokens_on_token", unique: true, using: :btree
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
  add_foreign_key "submissions", "events"
  add_foreign_key "submissions", "users"
end
