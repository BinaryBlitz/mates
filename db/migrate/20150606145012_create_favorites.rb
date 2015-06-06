class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :favorited, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :favorites, [:user_id, :favorited_id], unique: true
  end
end
