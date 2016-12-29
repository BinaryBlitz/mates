class CreateSocialTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :social_tokens do |t|
      t.string :service_type
      t.integer :social_id

      t.timestamps
    end
  end
end
