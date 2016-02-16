class DropPreferences < ActiveRecord::Migration
  def up
    drop_table :preferences
  end

  def down
    create_table "preferences", force: :cascade do |t|
      t.integer  "user_id"
      t.boolean  "notifications_friends", default: true
      t.boolean  "notifications_events",  default: true
      t.string   "visibility_photos",     default: "public"
      t.string   "visibility_events",     default: "public"
      t.datetime "created_at",            null: false
      t.datetime "updated_at",            null: false
    end
  end
end
