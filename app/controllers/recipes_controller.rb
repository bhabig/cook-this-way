class RecipesController < ApplicationController

  get '/recipes' do
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
    erb :'/recipes/index'
  end

  get '/recipes/:slug' do
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
    flash[:message] = "Test flash message"
    @recipe = Recipe.find_by_slug(params[:slug])
    erb :'/recipes/show_recipe'
  end
end
