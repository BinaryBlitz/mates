class UsersController < ApplicationController
  skip_before_action :restrict_access, only: [:create]
  before_action :set_user,
                only: [
                  :update, :destroy, :events, :friends,
                  :notify, :available_events
                ]

  def show
    @user = User.includes(:friends, :photos).find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render :authenticate, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @user

    if @user.update(user_params)
      head :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user
    @user.destroy
    head :no_content
  end

  def events
    @events = @user.events.upcoming.order(starts_at: :desc)
    render 'events/index'
  end

  def friends
    @friends = @user.friends
    render 'friends/index'
  end

  def search
    @users = User.search_by_name(params[:name])
    render :index
  end

  def available_events
    @events = current_user.events - @user.events - @user.invited_events - @user.submitted_events
    render 'events/index'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :birthday,
      :gender, :city, :avatar, :remove_avatar, :phone_number, :verification_token,
      photos_attributes: [:id, :image, :_destroy],
      interests_attributes: [:id, :category_id, :_destroy],
      preference_attributes: [
        :notifications_friends, :notifications_events, :visibility_photos, :visibility_events
      ]
    )
  end
end
