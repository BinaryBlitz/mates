class RemoveNotificationsMessagesFromPreferences < ActiveRecord::Migration
  def change
    remove_column :preferences, :notifications_messages, :string
  end
end
