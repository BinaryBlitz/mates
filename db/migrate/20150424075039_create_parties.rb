class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name
      t.string :target
      t.datetime :start_at
      t.datetime :end_at
      t.string :city
      t.float :latitude
      t.float :longitude
      t.text :info
      t.string :visible

      t.timestamps null: false
    end
  end
end
