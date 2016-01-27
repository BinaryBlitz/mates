class DropFeeds < ActiveRecord::Migration
  def up
    drop_table :feeds
  end

  def down
    create_table :feeds do |t|
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
