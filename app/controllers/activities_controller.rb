class ActivitiesController < ApplicationController
  def show
    @activity = Activity.new(current_user)
  end
end
