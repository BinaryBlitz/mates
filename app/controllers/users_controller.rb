class UsersController < ApplicationController
  skip_before_action :restrict_access,
                     only: [:create, :authenticate, :authenticate_vk, :authenticate_fb]
  before_action :set_user,
                only: [:show, :update, :destroy, :events, :friends, :favorite, :unfavorite]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render :show, status: :created, location: @user
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
    @user = User.find_by(nickname: params[:nickname])

    if @user && @user.authenticate(params[:password])
      render :authenticate, location: @user
    else
      render json: { error: 'Invalid nickname / password combination' }, status: :unauthorized
    end
  end

  def authenticate_vk
    return unless params[:token].present?
    vk = VkontakteApi::Client.new(params[:token])
    @user = User.find_or_create_from_vk(vk)

    render :authenticate, location: @user
  end

  def authenticate_fb
    return unless params[:token].present?
    graph = Koala::Facebook::API.new(params[:token])
    @user = User.find_or_create_from_fb(graph)

    render :authenticate, location: @user
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :nickname,
      :password, :password_confirmation, :birthday,
      :gender, :city, :avatar, :phone_number
    )
  end
end
