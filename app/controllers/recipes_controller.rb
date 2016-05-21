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
    @recipe = Recipe.find_by_id(params[:id])
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

  get '/recipes/:id/:slug/edit' do
    @recipe = Recipe.find_by_id(params[:id])
    if !session[:user_id]
      flash[:message] = "You must be signed in to edit a recipe."
      redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
    end
    @user = User.find_by_id(session[:user_id])
    if @user == @recipe.user
      erb :'recipes/edit_recipe'
    else
      flash[:message] = "You can only edit your recipes."
      redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
    end
  end

  post '/recipes/:id/:slug' do
    @recipe = Recipe.find_by_id(params[:id])
    @recipe.update(params[:recipe])
    @recipe.tags.clear
    params["recipe"]["tag_ids"].each do |tag|
      @recipe.tags << Tag.find_by_id(tag)
    end
    @recipe.ingredients.clear
    params["ingredient"].each do |ingredient|
      @recipe.ingredients << Ingredient.create(name: ingredient[:name], amount: ingredient[:amount], measurement_type: ingredient[:measurement_type])
    end
    flash[:message] = "You have successfully editted your recipe."
    redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
  end

  get '/recipes/:id/:slug/makeit' do
    @recipe = Recipe.find_by_id(params[:id])
    if !session[:user_id]
      flash[:message] = "You must be signed in to make a recipe your own."
      redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
    end
    @user = User.find_by_id(session[:user_id])
    if @user == @recipe.user
      flash[:message] = "That recipe already belongs to you."
      redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
    else
      erb :'recipes/makeit_recipe'
    end
  end

  post '/recipes/makeit' do
    user = User.find_by_id(session[:user_id])
    @recipe = Recipe.create(name: params["recipe"]["name"], user_id: session[:user_id], instructions: params["recipe"]["instructions"], category_id: params["recipe"]["category_id"])
    params["recipe"]["tag_ids"].each do |tag|
      @recipe.tags << Tag.find_by_id(tag)
    end
    params["ingredient"].each do |ingredient|
      @recipe.ingredients << Ingredient.create(name: ingredient[:name], amount: ingredient[:amount], measurement_type: ingredient[:measurement_type])
    end
    flash[:message] = "You have successfully made it your own!"
    redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
  end
end
