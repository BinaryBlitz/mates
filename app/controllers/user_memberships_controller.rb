class UserMembershipsController < ApplicationController
  before_action :set_user, only: [:index, :create]

  def index
    @memberships = @user.memberships.order_by_starting_date.visible_for(current_user)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
