class RemoveSocialAuthFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :vk_id, :integer
    remove_column :users, :facebook_id, :integer
  end
end
