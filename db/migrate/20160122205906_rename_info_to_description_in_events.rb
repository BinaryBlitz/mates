class RenameInfoToDescriptionInEvents < ActiveRecord::Migration
  def change
    rename_column :events, :info, :description
  end
end
