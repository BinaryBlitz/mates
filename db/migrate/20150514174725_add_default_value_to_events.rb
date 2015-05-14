class AddDefaultValueToEvents < ActiveRecord::Migration
  def change
    change_column :events, :user_limit, :integer, default: 1
  end
end
