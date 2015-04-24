class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]

  def index
    @events = current_user.events
  end

  def show
  end

  def create
    @event = current_user.events.new(articles_params)

    if @event.save
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

  private

  def set_event
    @event = current_user.events.find(params[:id])
  end

  def events_params
    params.require(:event).permit(:name, :target, :start_at,
    :end_at, :city, :adress, :latitude, :longitude, :info, :visible)
  end
end