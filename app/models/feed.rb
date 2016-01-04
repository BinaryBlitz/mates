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

  def friends
    friend_ids = user.friends.ids
    # 1. Created by friends
    created_ids = Event.where(creator_id: friend_ids).where(visibility: ['public', 'friends']).ids
    # 2. Participated by friends
    participated_ids = Event.joins(:memberships).where('memberships.user_id': friend_ids).public_events.ids
    # 3. Created by user
    user_event_ids = user.events.ids
    # Feed
    ids = (created_ids + participated_ids + user_event_ids).uniq
    events = Event.where(id: ids).upcoming.visible_for(user)
  end

  def recommended
    Event.where(category: user.categories).public_events
  end
end
