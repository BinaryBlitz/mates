class ChangeUserLimitInEvents < ActiveRecord::Migration
  def change
    change_column :events, :user_limit, :integer, default: nil
  end
end
