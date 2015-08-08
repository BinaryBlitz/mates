class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :name
      t.integer :event_type_id
      t.string :visibility
      t.datetime :min_starts_at
      t.datetime :max_starts_at

      t.timestamps null: false
    end
  end
end
