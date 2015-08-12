class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.belongs_to :user, index: true
      t.string :image

      t.timestamps null: false
    end
  end
end
