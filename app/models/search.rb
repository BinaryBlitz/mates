# == Schema Information
#
# Table name: searches
#
#  id            :integer          not null, primary key
#  name          :string
#  event_type_id :integer
#  visibility    :string
#  min_starts_at :datetime
#  max_starts_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Search < ActiveRecord::Base
  def events
    @events || find_events
  end

  private

  def find_events
    events = Event.order(starts_at: :asc)
    events = events.where('name ILIKE ?', "%#{name}%") if name.present?
    events = events.where(event_type_id: event_type_id) if event_type_id.present?
    events = events.where(visibility: visibility) if visibility.present?
    events = events.where('starts_at >= ?', min_starts_at) if min_starts_at.present?
    events = events.where('starts_at <= ?', max_starts_at) if max_starts_at.present?
    events
  end
end
