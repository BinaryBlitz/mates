class DeviceTokensController < ApplicationController
  before_action :set_device_token

  def create
    current_user.device_tokens.create(device_token_params)
    head :created
  end

  def destroy
    @device_token.destroy
    head :no_content
  end

  private

  def set_device_token
    @device_token = DeviceToken.find_by(token: params[:token])
  end

  def device_token_params
    params.require(:device_token).permit(:token, :platform)
  end
end
