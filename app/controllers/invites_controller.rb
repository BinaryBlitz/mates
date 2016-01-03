class InvitesController < ApplicationController
  before_action :set_event, only: [:index, :create]
  before_action :set_invite, only: [:update, :destroy]

  def index
    @invites = @event.invites
  end

  def create
    @invite = @event.invites.build(invite_params)
    authorize @invite

    if @invite.save
      render :show, status: :created
    else
      render json: @invite.errors, status: 422
    end
  end

  def update
    authorize @invite
    @invite.accept
    head :ok
  end

  def destroy
    authorize @invite
    @invite.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_invite
    @invite = Invite.find(params[:id])
  end

  def invite_params
    params.require(:invite).permit(:user_id)
  end
end
