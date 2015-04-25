class AddAdminRefToEvent < ActiveRecord::Migration
  def change
    add_reference :events, :admin, index: true, foreign_key: true
  end
end
