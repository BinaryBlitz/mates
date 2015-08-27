class AddSharingTokenToEvents < ActiveRecord::Migration
  def change
    add_column :events, :sharing_token, :string
  end
end
