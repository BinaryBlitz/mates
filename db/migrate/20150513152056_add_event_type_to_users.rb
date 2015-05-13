class AddEventTypeToUsers < ActiveRecord::Migration
  def change
    add_reference :events, :event_type, index: true, foreign_key: true
    remove_column :events, :target
  end
end
