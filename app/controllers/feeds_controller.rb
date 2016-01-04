class FeedsController < ApplicationController
  before_action :set_feed

  def friends
    @events = @feed.friends
    render 'events/index'
  end

  def recommended
    @events = @feed.recommended
    render 'events/index'
  end

  private

  def set_feed
    @feed = current_user.build_feed
  end
end
