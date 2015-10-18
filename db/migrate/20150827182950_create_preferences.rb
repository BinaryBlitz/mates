class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.boolean :notifications_friends, default: true
      t.boolean :notifications_favorites, default: true
      t.boolean :notifications_events, default: true
      t.boolean :notifications_messages, default: true
      t.string :visibility_photos, default: 'public'
      t.string :visibility_events, default: 'public'

      t.timestamps null: false
    end
  end
end
