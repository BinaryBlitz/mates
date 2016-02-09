class Feed
  def initialize(user)
    @user = user
  end

  def friends
    Rails.cache.fetch(['feed-friends', @user], expires_in: 2.minutes) do
      friend_ids = @user.friends.ids
      # 1. Created by friends
      created_ids = Event.where(creator_id: friend_ids).where(visibility: ['public', 'friends']).ids
      # 2. Participated by friends
      participated_ids = Event.joins(:memberships).where('memberships.user_id': friend_ids).public_events.ids
      # 3. Created by user
      user_event_ids = @user.events.ids
      # Feed
      ids = (created_ids + participated_ids + user_event_ids).uniq
      events = Event.where(id: ids).upcoming.visible_for(@user).order(starts_at: :desc)
    end
  end

  def recommended
    Rails.cache.fetch(['feed-recommended', @user], expires_in: 2.minutes) do
      Event.where(category: @user.categories).public_events.order(starts_at: :desc)
    end
  end
end
