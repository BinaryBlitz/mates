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
      ids = (created_ids - @user.owned_event_ids - @user.event_ids).uniq
      events = Event.where(id: ids)
        .upcoming
        .allowed_for(@user)
        .not_full
        .order(starts_at: :desc)
    end
  end

  def recommended(location)
    Rails.cache.fetch(['feed-recommended', @user], expires_in: 2.minutes) do
      categories = @user.categories.any? ? @user.categories : Category.all
      Event.where(category: categories)
        .upcoming
        .visible_for(@user)
        .near(location, 100, units: :km)
        .order(starts_at: :desc)
    end
  end
end
