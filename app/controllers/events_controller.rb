class EventsController < ApplicationController
  before_action :set_event, except: [:index, :create]

  # Participated events
  def index
    @events = current_user.events
  end

  def show
  end

  def create
    @event = current_user.owned_events.build(events_params)

    if @event.save
      current_user.events << @event
      render :show, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(events_params)
      render :show, status: :ok, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    head :no_content
  end

  # Events created by current user
  def owned
    @events = current_user.owned_events
    render :index
  end

  # Leave the event
  def leave
    head :unprocessable_entity and return if current_user == @event.admin

    current_user.events.destroy(@event)
    head :no_content
  end

  # Admin only action
  def remove
    user = @event.users.find(params[:user_id])
    @event.users.destroy(user)
    head :no_content
  end

  def proposals
    # Admin only action
    @proposals = @event.proposals
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def events_params
    params.require(:event)
      .permit(
        :name, :target, :start_at, :end_at,
        :city, :address, :latitude, :longitude,
        :info, :visible, :photo
      )
  end
end
