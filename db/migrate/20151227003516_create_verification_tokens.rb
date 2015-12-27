class CreateVerificationTokens < ActiveRecord::Migration
  def change
    create_table :verification_tokens do |t|
      t.string :token
      t.string :phone_number
      t.integer :code
      t.boolean :verified

      t.timestamps null: false
    end
  end
end
