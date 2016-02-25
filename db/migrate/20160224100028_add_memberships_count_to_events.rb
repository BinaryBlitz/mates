class AddMembershipsCountToEvents < ActiveRecord::Migration
  def change
    add_column :events, :memberships_count, :integer, default: 0, null: false

    Event.all.each do |event|
      Event.reset_counters(event.id, :memberships)
    end
  end
end
