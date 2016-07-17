class API::EventMembershipsController < API::APIController
  before_action :set_event, only: [:index, :create]

  def index
    @memberships = @event.memberships
  end

  def create
    @membership = @event.memberships.build(user: current_user)
    authorize @membership

    if @membership.save
      render :show, status: :created
    else
      render json: @membership.errors, status: 422
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_membership
    @membership = Membership.find(params[:id])
  end

  def membership_params
    params.require(:membership).permit(:event_id)
  end
end
