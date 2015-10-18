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
#

class Search < ActiveRecord::Base
  def events
    @events || find_events
  end

  private

  def find_events
    events = Event.order(starts_at: :asc)
    events = events.where('name ILIKE ?', "%#{name}%") if name.present?
    events = events.where(visibility: visibility) if visibility.present?
    events = events.where('starts_at >= ?', min_starts_at) if min_starts_at.present?
    events = events.where('starts_at <= ?', max_starts_at) if max_starts_at.present?
    events = events.on_dates(dates) if dates.present?
    events = events.near([latitude, longitude], distance, units: :km) if location_present?

    if category_id.present?
      events = events.where('category_id IS :id OR extra_category_id IS :id', id: category_id)
    end

    if category_ids.present?
      events = events.where('category_id IN (:ids) OR extra_category_id IN (:ids)', ids: category_ids)
    end

    events
  end

  def location_present?
    latitude.present? && longitude.present? && distance.present?
  end
end
