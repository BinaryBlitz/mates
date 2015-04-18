class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :nickname
      t.date :birthday
      t.boolean :gender
      t.string :api_token

      t.timestamps null: false
    end
  end
end
