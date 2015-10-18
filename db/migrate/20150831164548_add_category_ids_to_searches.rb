class AddCategoryIdsToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :category_ids, :integer, array: true
  end
end
