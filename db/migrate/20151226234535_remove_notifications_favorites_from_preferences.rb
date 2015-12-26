class RemoveNotificationsFavoritesFromPreferences < ActiveRecord::Migration
  def change
    remove_column :preferences, :notifications_favorites, :boolean
  end
end
