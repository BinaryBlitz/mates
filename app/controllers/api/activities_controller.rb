class API::ActivitiesController < API::APIController
  def show
    @activity = Activity.new(current_user)
  end
end
