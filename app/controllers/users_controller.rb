class UsersController < ApplicationController
  skip_before_action :restrict_access,
                     only: [:create, :authenticate, :authenticate_vk, :authenticate_fb]
  before_action :set_user,
                only: [
                  :update, :destroy, :events, :friends, :favorite, :unfavorite,
                  :notify, :available_events
                ]

  # GET /users/1
  def show
    @user = User.includes(:friends, :photos).find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render :authenticate, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    authorize @user
    if @user.update(user_params)
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    authorize @user
    @user.destroy
    head :no_content
  end

  def authenticate
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      render json: { id: @user.id, api_token: @user.api_token }
    else
      render json: { error: 'Invalid email / password combination' }, status: :unauthorized
    end
  end

  def authenticate_vk
    if params[:token].present?
      vk = VkontakteApi::Client.new(params[:token])
      @user = User.find_or_create_from_vk(vk)
      render json: { id: @user.id, api_token: @user.api_token }
    else
      head 422
    end
  end

  def authenticate_fb
    if params[:token].present?
      graph = Koala::Facebook::API.new(params[:token])
      @user = User.find_or_create_from_fb(graph)
      render json: { id: @user.id, api_token: @user.api_token }
    else
      head 422
    end
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

  def favorite
    current_user.favorited_users << @user
    head :created
  end

  def unfavorite
    current_user.favorited_users.destroy(@user)
    head :no_content
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

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :password, :birthday,
      :gender, :city, :avatar, :remove_avatar, :phone_number,
      :vk_url, :facebook_url, :twitter_url, :instagram_url,
      photos_attributes: [:id, :image, :_destroy],
      interests_attributes: [:id, :category_id, :_destroy],
      preference_attributes: [
        :notifications_friends, :notifications_favorites,
        :notifications_events, :notifications_messages,
        :visibility_photos, :visibility_events
      ]
    )
  end
end
