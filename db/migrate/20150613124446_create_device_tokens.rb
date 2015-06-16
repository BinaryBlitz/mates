class CreateDeviceTokens < ActiveRecord::Migration
  def change
    create_table :device_tokens do |t|
      t.string :token
      t.string :platform
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
