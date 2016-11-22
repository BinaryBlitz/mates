class API::UsersController < API::APIController
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
      render :authenticate, status: :created
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

  def friends
    @friends = @user.friends
    render 'api/friends/index'
  end

  def search
    @users = User.search_by_name(params[:name])
    render :index
  end

  def authenticate_layer
    token = Layer::IdentityToken.new(
      current_user.id, params[:nonce], (Time.now+(86400*14)),
      display_name: current_user.full_name,
      avatar_url: current_user.avatar.thumb.url
    )
    render json: { token: token }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :birthday, :website_url,
      :gender, :city, :avatar, :remove_avatar, :phone_number, :verification_token,
      :notifications_events, :notifications_friends,
      photos_attributes: [:id, :image, :_destroy],
      interests_attributes: [:id, :category_id, :_destroy]
    )
  end
end
