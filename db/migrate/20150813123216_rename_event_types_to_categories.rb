class RenameEventTypesToCategories < ActiveRecord::Migration
  def change
    rename_table :event_types, :categories
    rename_column :events, :event_type_id, :category_id
    rename_column :searches, :event_type_id, :category_id
  end
end
