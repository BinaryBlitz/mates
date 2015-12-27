class RemoveSocialNetworksFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :vk_url, :string
    remove_column :users, :facebook_url, :string
    remove_column :users, :twitter_url, :string
    remove_column :users, :instagram_url, :string
  end
end
