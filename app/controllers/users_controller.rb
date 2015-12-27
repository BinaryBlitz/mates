class UsersController < ApplicationController
  skip_before_action :restrict_access,
                     only: [:create, :authenticate]
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

    if authenticated? && @user.update(user_params)
      head :no_content
    else
      @user.errors.add(:current_password, "is incorrect") if user_params[:password].present?
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user
    @user.destroy
    head :no_content
  end

  def authenticate_phone_number
    @user = User.find_by(phone_number: params[:phone_number])

    if @user && @user.authenticate(params[:password])
      render :authenticate
    else
      render json: { error: 'Invalid phone number / password combination' }, status: :unauthorized
    end
  end

  def authenticate_layer
    token = Layer::IdentityToken.new(current_user.id, params[:nonce])
    render json: { token: token }
  end

  def events
    @events = @user.events
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

  def notify
    message = params[:message]

    if message.blank?
      head :unprocessable_entity
    else
      @user.notify_message(message, current_user)
      head :created
    end
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
      :first_name, :last_name, :password, :birthday,
      :gender, :city, :avatar, :remove_avatar, :phone_number, :verification_token,
      photos_attributes: [:id, :image, :_destroy],
      interests_attributes: [:id, :category_id, :_destroy],
      preference_attributes: [
        :notifications_friends,
        :notifications_events, :notifications_messages,
        :visibility_photos, :visibility_events
      ]
    )
  end

  def authenticated?
    user_params[:password].blank? || @user.authenticate(params[:user][:current_password])
  end
end
