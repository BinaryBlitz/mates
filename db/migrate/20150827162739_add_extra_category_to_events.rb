class AddExtraCategoryToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :extra_category, index: true
  end
end
