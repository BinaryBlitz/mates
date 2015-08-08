class SearchesController < ApplicationController
  def show
    @events = Search.find(params[:id]).events
    render 'events/index'
  end

  def create
    @search = Search.create!(params[:search])
    render :show, status: :created, location: @search
  end
end
