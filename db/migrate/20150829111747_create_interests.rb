class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.references :category, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
