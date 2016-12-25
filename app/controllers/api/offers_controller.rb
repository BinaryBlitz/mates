class API::OffersController < API::APIController
  before_action :set_offers

  def index
  end

  def number_of_incoming
    render json: @offers.number_of_incoming
  end

  private

  def set_offers
    @offers = Offers.new(current_user)
  end
end
