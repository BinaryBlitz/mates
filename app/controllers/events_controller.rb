class EventsController < ApplicationController
  before_action :set_event, except: [:index, :create, :owned]

  # Participated events
  def index
    @events = current_user.events
  end

  def show
  end

  def create
    @event = current_user.owned_events.build(events_params)

    if @event.save
      render :show, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @event
    if @event.update(events_params)
      render :show, status: :ok, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @event
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
    authorize @event
    current_user.events.destroy(@event)
    head :no_content
  end

  # Remove user from the event
  def remove
    authorize @event
    user = @event.users.find(params[:user_id])
    @event.users.destroy(user)
    head :no_content
  end

  # List of proposed users
  def proposals
    authorize @event
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
