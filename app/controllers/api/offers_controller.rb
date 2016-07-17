class API::OffersController < API::APIController
  def index
    @offers = Offers.new(current_user)
  end
end
