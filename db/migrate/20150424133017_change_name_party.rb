class ChangeNameParty < ActiveRecord::Migration
  def up
    rename_table :parties, :events
  end

  def down
    rename_table :events, :parties
  end
end
