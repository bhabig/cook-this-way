class RecipesController < ApplicationController

  get '/recipes' do
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
    erb :'/recipes/index'
  end

  get '/recipes/:id/:slug' do
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
    flash[:message] = "Test flash message"
    @recipe = Recipe.find_by_slug(params[:slug])
    erb :'/recipes/show_recipe'
  end

  get '/recipes/new' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      erb :'recipes/create_recipe'
    else
      flash[:message] = "You must be signed in to add a recipe"
      erb :'users/signup'
    end
  end
end
