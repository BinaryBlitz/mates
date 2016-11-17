class ChangeCodeInVerificationTokens < ActiveRecord::Migration[5.0]
  def up
    change_column :verification_tokens, :code, :string, null: false
  end

  def down
    change_column :verification_tokens, :code, 'integer USING CAST(code AS integer)', null: false
  end
end
