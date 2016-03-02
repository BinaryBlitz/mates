class Feed
  def initialize(user)
    @user = user
  end

  def friends
    Rails.cache.fetch(['feed-friends', @user], expires_in: 2.minutes) do
      friend_ids = @user.friends.ids
      # Created by friends
      created_ids = Event.where(creator_id: friend_ids).where(visibility: ['public', 'friends']).ids
      # Feed
      ids = (created_ids - @user.owned_event_ids).uniq
      events = Event.where(id: ids).upcoming.available_for(@user).order(starts_at: :desc)
    end
  end

  def recommended
    Rails.cache.fetch(['feed-recommended', @user], expires_in: 2.minutes) do
      categories = @user.categories.any? ? @user.categories : Category.all
      Event.where(category: categories)
        .where.not(id: @user.owned_events.ids)
        .where.not(id: Event.created_by_friends_of(@user).ids)
        .upcoming
        .public_events
        .order(starts_at: :desc)
    end
  end
end
