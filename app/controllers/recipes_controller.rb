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

  post '/recipes' do
    user = User.find_by_id(session[:user_id])
    @recipe = Recipe.create(name: params["recipe"]["name"], user_id: session[:user_id], instructions: params["recipe"]["instructions"], category_id: params["recipe"]["category_id"])
    params["recipe"]["tag_ids"].each do |tag|
      @recipe.tags << Tag.find_by_id(tag)
    end
    params["ingredient"].each do |ingredient|
      @recipe.ingredients << Ingredient.create(name: ingredient[:name], amount: ingredient[:amount], measurement_type: ingredient[:measurement_type])
    end
    redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
  end
end
