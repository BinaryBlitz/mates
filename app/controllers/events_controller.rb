class EventsController < ApplicationController
  before_action :set_event, except: [:index, :create, :owned, :feed]

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

  def submissions
    authorize @event
    @submissions = @event.submissions
    render 'submissions/index'
  end

  def feed
    @events = Event.feed_for(current_user)
    render :index
  end

  def join
    membership = Membership.new(user: current_user, event: @event)
    authorize membership, :create?

    if membership.save
      head :created
    else
      render json: membership.errors, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def events_params
    params.require(:event)
      .permit(
        :name, :start_at, :end_at,
        :city, :address, :latitude, :longitude,
        :info, :visible, :photo, :event_type_id
      )
  end
end
