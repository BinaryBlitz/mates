class AddEmailToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :nickname, :string
    add_column :users, :email, :string
    add_index :users, :email, unique: true
  end
end
