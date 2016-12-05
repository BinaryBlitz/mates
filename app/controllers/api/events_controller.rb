class API::EventsController < API::APIController
  before_action :set_event, except: [:create, :owned, :feed, :by_token, :default_photo]

  def show
  end

  def by_token
    @event = Event.find_by!(sharing_token: params[:sharing_token])
    render :show
  end

  def create
    @event = current_user.owned_events.build(events_params)

    if @event.save
      render :show, status: :created
    else
      render json: @event.errors, status: 422
    end
  end

  def update
    authorize @event

    if @event.update(events_params)
      head :ok
    else
      render json: @event.errors, status: 422
    end
  end

  def destroy
    authorize @event
    @event.destroy
    head :no_content
  end

  # Events created by current user
  def owned
    @events = current_user.owned_events
    render :index
  end

  def default_photo
    type = Category.types.key(params[:category])
    max = Rails.root.join('public', 'images', "#{type}").children.length
    random_number = [*1..max].sample
    url = Rails.root.join('public', 'images', "#{type}", "image#{random_number}.png")
    render json: url
  end

  # TODO: Deprecate
  def available_friends
    @users = current_user.friends - @event.users - @event.submitted_users - @event.invited_users
    render 'api/users/index'
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def events_params
    params.require(:event)
      .permit(
        :name, :starts_at, :city, :address, :latitude, :longitude,
        :description, :visible, :photo, :category_id, :extra_category_id, :user_limit,
        :min_age, :max_age, :gender, :visibility
      )
  end
end
