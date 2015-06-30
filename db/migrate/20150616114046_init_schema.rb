class InitSchema < ActiveRecord::Migration
  def up
    
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
    
    create_table "comments", force: :cascade do |t|
      t.string   "content"
      t.integer  "user_id"
      t.integer  "event_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    
    add_index "comments", ["event_id"], name: "index_comments_on_event_id", using: :btree
    add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree
    
    create_table "device_tokens", force: :cascade do |t|
      t.string   "token"
      t.string   "platform"
      t.integer  "user_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    
    add_index "device_tokens", ["user_id"], name: "index_device_tokens_on_user_id", using: :btree
    
    create_table "event_types", force: :cascade do |t|
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    
    create_table "events", force: :cascade do |t|
      t.string   "name"
      t.datetime "starts_at"
      t.datetime "ends_at"
      t.string   "city"
      t.float    "latitude"
      t.float    "longitude"
      t.text     "info"
      t.string   "visibility"
      t.datetime "created_at",                          null: false
      t.datetime "updated_at",                          null: false
      t.string   "address"
      t.integer  "admin_id"
      t.string   "photo"
      t.integer  "event_type_id"
      t.integer  "user_limit",              default: 1
      t.integer  "min_age"
      t.integer  "max_age"
      t.string   "gender",        limit: 1
    end
    
    add_index "events", ["admin_id"], name: "index_events_on_admin_id", using: :btree
    add_index "events", ["event_type_id"], name: "index_events_on_event_type_id", using: :btree
    
    create_table "favorites", force: :cascade do |t|
      t.integer  "user_id"
      t.integer  "favorited_id"
      t.datetime "created_at",   null: false
      t.datetime "updated_at",   null: false
    end
    
    add_index "favorites", ["favorited_id"], name: "index_favorites_on_favorited_id", using: :btree
    add_index "favorites", ["user_id", "favorited_id"], name: "index_favorites_on_user_id_and_favorited_id", unique: true, using: :btree
    add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree
    
    create_table "friend_requests", force: :cascade do |t|
      t.integer  "user_id"
      t.integer  "friend_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
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
    
    create_table "invites", force: :cascade do |t|
      t.integer  "user_id"
      t.integer  "event_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
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
    
    create_table "submissions", force: :cascade do |t|
      t.integer  "user_id"
      t.integer  "event_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    
    add_index "submissions", ["event_id"], name: "index_submissions_on_event_id", using: :btree
    add_index "submissions", ["user_id", "event_id"], name: "index_submissions_on_user_id_and_event_id", unique: true, using: :btree
    add_index "submissions", ["user_id"], name: "index_submissions_on_user_id", using: :btree
    
    create_table "users", force: :cascade do |t|
      t.string   "first_name"
      t.string   "last_name"
      t.string   "nickname"
      t.date     "birthday"
      t.string   "gender",                    default: "m"
      t.string   "api_token"
      t.datetime "created_at",                              null: false
      t.datetime "updated_at",                              null: false
      t.string   "avatar"
      t.integer  "vk_id"
      t.integer  "facebook_id",     limit: 8
      t.string   "password_digest"
      t.string   "city"
      t.string   "phone_number"
      t.string   "vk_url"
      t.string   "facebook_url"
      t.string   "twitter_url"
      t.string   "instagram_url"
    end
    
    add_foreign_key "comments", "events"
    add_foreign_key "comments", "users"
    add_foreign_key "device_tokens", "users"
    add_foreign_key "events", "event_types"
    add_foreign_key "favorites", "users"
    add_foreign_key "friend_requests", "users"
    add_foreign_key "friendships", "users"
    add_foreign_key "invites", "events"
    add_foreign_key "invites", "users"
    add_foreign_key "memberships", "events"
    add_foreign_key "memberships", "users"
    add_foreign_key "proposals", "events"
    add_foreign_key "proposals", "users"
    add_foreign_key "submissions", "events"
    add_foreign_key "submissions", "users"
  end

  def down
    raise "Can not revert initial migration"
  end
end
