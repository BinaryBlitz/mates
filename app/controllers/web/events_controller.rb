class Web::EventsController < ApplicationController
  skip_before_action :restrict_access

  layout 'web/layouts/application'

  def show
    @event = Event.find(params[:sharing_token])
  end
end
