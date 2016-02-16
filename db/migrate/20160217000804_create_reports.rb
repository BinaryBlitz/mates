class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.text :content, null: false
      t.belongs_to :user, index: true
      t.belongs_to :event, index: true

      t.timestamps null: false
    end
  end
end
