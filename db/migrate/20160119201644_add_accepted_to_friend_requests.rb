class AddAcceptedToFriendRequests < ActiveRecord::Migration
  def change
    add_column :friend_requests, :accepted, :boolean
  end
end
