class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :restrict_access
  include Pundit

  attr_reader :current_user
  helper_method :current_user

  def restrict_access
    unless restrict_access_by_params
      render json: { message: 'Invalid API Token' }, status: 401
      return
    end
  end

  def restrict_access_by_params
    return true if @current_user

    @current_user = User.find_by_api_token(params[:api_token])
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    head :forbidden
  end
end
