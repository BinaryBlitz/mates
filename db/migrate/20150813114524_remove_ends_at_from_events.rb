class RemoveEndsAtFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :ends_at, :datetime
  end
end
