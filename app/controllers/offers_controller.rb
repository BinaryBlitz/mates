class OffersController < ApplicationController
  def index
    @offers = Offers.new(current_user)
  end
end
