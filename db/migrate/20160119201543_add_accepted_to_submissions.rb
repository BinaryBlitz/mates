class AddAcceptedToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :accepted, :boolean
  end
end
