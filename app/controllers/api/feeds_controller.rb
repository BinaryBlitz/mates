class API::FeedsController < API::APIController
  before_action :set_feed

  def friends
    @events = @feed.friends(location)
  end

  def recommended
    @events = @feed.recommended(location)
  end

  private

  def set_feed
    @feed = Feed.new(current_user)
  end

  def location_params
    params.permit(:latitude, :longitude)
  end

  def location
    [location_params[:latitude].to_f, location_params[:longitude].to_f]
  end
end
