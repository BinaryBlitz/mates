# == Schema Information
#
# Table name: feeds
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Feed < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true

  # TODO: Cache this thing
  # TODO: Take limitations and visibility into account
  # TODO: Exclude owned, participated and pending events
  def events
    # ids = (user_events + events_of_friends).uniq
    # Event.where(id: ids).includes(:creator)
    Event.includes(:creator).all
  end

  private

  # Owned and participating
  def user_events
    user.owned_events.upcoming.ids + user.events.upcoming.ids
  end

  # Do not cache this thing
  def events_of_friends
    ids = user.friends.ids
    created_ids = Event.where(creator_id: ids).upcoming.ids
    participating_ids = Event.joins(:memberships).where('memberships.user_id': ids).upcoming.ids
    created_ids + participating_ids
  end

  # def events_from_users(ids)
  #   created_ids = Event.where(creator_id: ids).upcoming.ids
  #   participating_ids = Event.joins(:memberships).where('memberships.user_id': ids).upcoming.ids
  #   created_ids + participating_ids
  # end

  # TODO: Cache this thing too
  def recommended_events
  end
end
