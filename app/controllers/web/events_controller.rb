class Web::EventsController < API::APIController
  skip_before_action :restrict_access

  layout 'web/layouts/application', except: [:frontend_show]

  def show
    @event = Event.find_by!(sharing_token: params[:sharing_token])
  end

  def frontend_show
    @event = Event.find(params[:id])
    render 'web/events/frontend_show'
  end
end
