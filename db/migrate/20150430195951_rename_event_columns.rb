class RenameEventColumns < ActiveRecord::Migration
  def change
    rename_column :events, :start_at, :starts_at
    rename_column :events, :end_at, :ends_at
    rename_column :events, :visible, :visibility
  end
end
