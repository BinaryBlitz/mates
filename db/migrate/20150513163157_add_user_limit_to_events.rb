class AddUserLimitToEvents < ActiveRecord::Migration
  def change
    add_column :events, :user_limit, :integer
  end
end
