class AddVkIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vk_id, :integer
    add_column :users, :facebook_id, :integer
  end
end
