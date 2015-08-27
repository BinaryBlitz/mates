class SearchesController < ApplicationController
  def show
    @search = Search.find(params[:id])
  end

  def create
    @search = Search.create!(search_params)
    render :show, status: :created, location: @search
  end

  private

  def search_params
    params.require(:search)
      .permit(
        :name, :category_id, :visibility,
        :min_starts_at, :max_starts_at,
        :latitude, :longitude, :distance,
        dates: [])
  end
end
