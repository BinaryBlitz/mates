class MembershipsController < ApplicationController
  before_action :set_event, only: [:create]

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
    @membership = current_user.memberships.find(params[:id])
    authorize @membership
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def membership_params
    params.require(:membership).permit(:event_id)
  end
end
