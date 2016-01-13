class UserMembershipsController < ApplicationController
  before_action :set_user, only: [:index, :create]

  def index
    @memberships = @user.memberships
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
