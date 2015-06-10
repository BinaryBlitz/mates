class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :event, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :submissions, [:user_id, :event_id], unique: true
  end
end
