class AddIndexesToVerificationTokens < ActiveRecord::Migration[5.0]
  def change
    add_index :verification_tokens, :token, unique: true
    add_index :verification_tokens, :phone_number
  end
end
