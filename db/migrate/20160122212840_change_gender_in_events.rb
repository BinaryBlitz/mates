class ChangeGenderInEvents < ActiveRecord::Migration
  def up
    change_column :events, :gender, :string
    change_column :users, :gender, :string, default: nil
  end
end
