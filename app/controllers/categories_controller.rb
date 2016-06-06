class CategoriesController < ApplicationController
  get '/categories' do
    if logged_in?
      @user = current_user
    end
    erb :'/categories/index'
  end

  get '/categories/:slug' do
    if logged_in?
      @user = current_user
    end
    @category = find_category_by_slug
    @cat_page = @category.recipes
    erb :'/categories/show_category'
  end
end
