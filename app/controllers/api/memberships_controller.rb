class API::MembershipsController < API::APIController
  before_action :set_membership, only: [:destroy]

  def destroy
    authorize @membership
    @membership.destroy
    head :no_content
  end

  private

  def set_membership
    @membership = Membership.find(params[:id])
  end
end
