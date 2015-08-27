class AddDatesToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :dates, :date, array: true
  end
end
