class Feed < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true

  # TODO: Cache this thing
  def events
    Event.where(id: user_events + events_of_friends).includes(:admin)# + events_of_friends_of_friends + recommended_events
  end

  private

  # Owned and participating
  def user_events
    user.owned_events.upcoming.ids + user.events.upcoming.ids
  end

  # Do not cache this thing
  def events_of_friends
    ids = user.friends.ids
    created_ids = Event.where(admin_id: ids).upcoming.ids
    participating_ids = Event.joins(:memberships).where('memberships.user_id': ids).upcoming.ids
    created_ids + participating_ids
  end

  # TODO: Cache this thing
  def events_of_friends_of_friends
  end

  # TODO: Cache this thing too
  def recommended_events
  end
end
