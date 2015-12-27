class RenameAdminToCreatorInEvents < ActiveRecord::Migration
  def change
    rename_column :events, :admin_id, :creator_id
  end
end
