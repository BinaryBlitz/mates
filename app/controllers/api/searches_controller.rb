class API::SearchesController < API::APIController
  def show
    @search = Search.find(params[:id])
  end

  def create
    @search = current_user.searches.create!(search_params)
    render :show, status: :created
  end

  private

  def search_params
    params.require(:search).permit(:category_id, :latitude, :longitude)
  end
end
