class Web::EventsController < API::APIController
  skip_before_action :restrict_access

  layout 'web/layouts/application'

  def show
    @event = Event.find_by!(sharing_token: params[:sharing_token])
  end
end
