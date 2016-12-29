class AddSocialAuthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :vk_id, :integer
    add_column :users, :fb_id, :integer
    add_column :users, :tw_id, :integer
  end
end
