class InvitesController < ApplicationController
  before_action :set_invite, only: [:show, :update, :destroy]

  def show
  end

  # Invite user
  def create
    @invite = Invite.new(invite_params)

    if @invite.save
      render :show, status: :created, location: @invite
    else
      render json: @invite.errors, status: :unprocessable_entity
    end
  end

  # Accept the invite
  def update
    @invite.accept
    head :no_content
  end

  # Decline or cancel the invite
  def destroy
    @invite.destroy
    head :no_content
  end

  private

  def set_invite
    @invite = Invite.find(params[:id])
  end

  def invite_params
    params.require(:invite).permit(:user_id, :event_id)
  end
end
