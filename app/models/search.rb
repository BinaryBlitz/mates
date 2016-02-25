# == Schema Information
#
# Table name: searches
#
#  id            :integer          not null, primary key
#  name          :string
#  category_id   :integer
#  visibility    :string
#  min_starts_at :datetime
#  max_starts_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  dates         :date             is an Array
#  latitude      :float
#  longitude     :float
#  distance      :integer
#  category_ids  :integer          is an Array
#  user_id       :integer
#

class Search < ActiveRecord::Base
  belongs_to :user

  def events
    @events || find_events
  end

  private

  def find_events
    events = Event.order(starts_at: :asc).upcoming
    events = events.where(category_id: category_id) if category_id.present?
    events.available_for(user)
  end
end
