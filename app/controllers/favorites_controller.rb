class FavoritesController < ApplicationController
  def index
    @users = current_user.favorited_users
    render 'users/index'
  end
end
