class ChangeGender < ActiveRecord::Migration
  def change
    change_column :users, :gender, :string, default: 'm'
  end
end
