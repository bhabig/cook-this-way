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
    @category = Category.find_by_name(@recipe.category.name)
    erb :'/recipes/show_recipe'
  end

  get '/recipes/new' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      erb :'recipes/create_recipe'
    else
      flash[:message] = "You must be signed in to add a recipe"
      redirect to '/signup'
    end
  end

  post '/recipes' do
    user = User.find_by_id(session[:user_id])
    @recipe = Recipe.create(name: params["recipe"]["name"].downcase, user_id: session[:user_id], instructions: params["recipe"]["instructions"], category_id: params["recipe"]["category_id"])
    params["ingredient"].each do |ingredient|
      @recipe.ingredients << Ingredient.create(name: ingredient[:name].downcase, amount: ingredient[:amount], measurement_type: ingredient[:measurement_type].downcase)
    end
    if params[:file]
      @recipe.avatar = params[:file]
    end
    @recipe.save!
    redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
  end

  get '/recipes/:id/:slug/edit' do
    @recipe = Recipe.find_by_id(params[:id])
    if !session[:user_id]
      flash[:message] = "You must be signed in to edit a recipe."
      redirect to '/signup'
    end
    @user = User.find_by_id(session[:user_id])
    if
      @user == @recipe.user
      erb :'recipes/edit_recipe'
    else
      flash[:message] = "You can only edit your recipes."
      redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
    end
  end

  post '/recipes/:id/:slug' do
    @recipe = Recipe.find_by_id(params[:id])
    @recipe.update(name: params["recipe"]["name"].downcase, user_id: session[:user_id], instructions: params["recipe"]["instructions"], category_id: params["recipe"]["category_id"])
    @recipe.ingredients.clear
    params["ingredient"].each do |ingredient|
      @recipe.ingredients << Ingredient.create(name: ingredient[:name].downcase, amount: ingredient[:amount], measurement_type: ingredient[:measurement_type].downcase)
    end
    if params[:file]
      @recipe.avatar = params[:file]
    else
      @recipe.remove_avatar!
    end
    @recipe.save!
    flash[:message] = "You have successfully editted your recipe."
    redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
  end

  get '/recipes/:id/:slug/makeit' do
    @recipe = Recipe.find_by_id(params[:id])
    if !session[:user_id]
      flash[:message] = "You must be signed in to make a recipe your own."
      redirect to "/signup"
    end
    @user = User.find_by_id(session[:user_id])
    if
      @user == @recipe.user
      flash[:message] = "That recipe already belongs to you."
      redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
    else
      erb :'recipes/makeit_recipe'
    end
  end

  post '/recipes/makeit' do
    user = User.find_by_id(session[:user_id])
    @recipe = Recipe.create(name: params["recipe"]["name"].downcase, user_id: session[:user_id], instructions: params["recipe"]["instructions"], category_id: params["recipe"]["category_id"])
    params["ingredient"].each do |ingredient|
      @recipe.ingredients << Ingredient.create(name: ingredient[:name].downcase, amount: ingredient[:amount], measurement_type: ingredient[:measurement_type].downcase)
    end
    if params[:file]
      @recipe.avatar = params[:file]
    else
      @recipe.remove_avatar!
    end
    @recipe.save!
    flash[:message] = "You have successfully made it your own!"
    redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
  end

  post '/recipes/:id/:slug/like' do
    @user = User.find_by_id(session[:user_id])
    @recipe = Recipe.find_by_id(params[:id])
    @recipe.liked_by @user
    redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
  end

  post '/recipes/:id/:slug/unlike' do
    @user = User.find_by_id(session[:user_id])
    @recipe = Recipe.find_by_id(params[:id])
    @recipe.unliked_by @user
    redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
  end

end
