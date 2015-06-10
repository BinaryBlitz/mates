class AddFiltersToEvents < ActiveRecord::Migration
  def change
    add_column :events, :min_age, :integer
    add_column :events, :max_age, :integer
    add_column :events, :gender, :string, limit: 1
  end
end
