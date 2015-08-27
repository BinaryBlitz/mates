class AddRespondentToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :respondent, index: true
  end
end
