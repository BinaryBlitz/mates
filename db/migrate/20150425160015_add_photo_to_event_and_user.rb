class AddPhotoToEventAndUser < ActiveRecord::Migration
  def change
    add_column :events, :photo, :string
    add_column :users, :avatar, :string
  end
end
