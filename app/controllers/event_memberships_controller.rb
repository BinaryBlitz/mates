class EventMembershipsController < ApplicationController
  before_action :set_event, only: [:index, :create]
  before_action :set_membership, only: [:destroy]

  def index
    @memberships = @event.memberships
  end

  def create
    @membership = @event.memberships.build(user: current_user)
    authorize @membership

    if @membership.save
      render :show, status: :created
    else
      render json: @membership.errors, status: 422
    end
  end

  def destroy
    authorize @membership
    @membership.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_membership
    @membership = Membership.find(params[:id])
  end

  def membership_params
    params.require(:membership).permit(:event_id)
  end
end
