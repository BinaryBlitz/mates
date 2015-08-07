class AddAvatarOriginalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_original, :string
  end
end
