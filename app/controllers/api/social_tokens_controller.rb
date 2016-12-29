class API::SocialTokensController < API::APIController
  skip_before_action :restrict_access

  def create
    @social_token = SocialToken.new(social_token_params)

    if @social_token.save
      render json: @social_token, status: :created
    else
      render json: @social_token.errors, status: 422
    end
  end

  private

  def social_token_params
    params.permit(:social_id, :service_type)
  end
end
