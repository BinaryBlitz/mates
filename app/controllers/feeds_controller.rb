class FeedsController < ApplicationController
  before_action :set_feed

  def friends
    @events = @feed.friends
  end

  def recommended
    @events = @feed.recommended
  end

  private

  def set_feed
    @feed = current_user.build_feed
  end
end
