class FriendRequestsController < ApplicationController
  before_action :set_friend_request, only: [:update, :destroy]

  def index
    @incoming = FriendRequest.where(friend: current_user)
    @outgoing = current_user.friend_requests
  end

  def create
    friend = User.find(params[:friend_id])
    @friend_request = current_user.friend_requests.build(friend: friend)

    if @friend_request.save
      render :show, status: :created, location: @friend_request
    else
      render json: @friend_request.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @friend_request
    @friend_request.accept
    head :no_content
  end

  def destroy
    authorize @friend_request
    @friend_request.decline
    head :no_content
  end

  private

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end
end
