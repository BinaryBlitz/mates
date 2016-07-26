class API::CategoriesController < API::APIController
  def index
    @categories = Category.all
  end
end
