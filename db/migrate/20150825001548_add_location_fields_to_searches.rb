class AddLocationFieldsToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :latitude, :float
    add_column :searches, :longitude, :float
    add_column :searches, :distance, :integer
  end
end
