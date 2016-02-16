class AddNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notifications_friends, :boolean, default: true, null: false
    add_column :users, :notifications_events, :boolean, default: true, null: false
  end
end
