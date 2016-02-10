class RemoveIndexFromSubmissions < ActiveRecord::Migration
  def change
    remove_index :submissions, [:user_id, :event_id]
  end
end
