class RecipesController < ApplicationController

  get '/recipes' do
    if logged_in?
      @user = current_user
    end
    erb :'/recipes/index'
  end

  get '/recipes/:id/:slug' do
    if logged_in?
      @user = current_user
    end
    @recipe = find_recipe_by_id
    @category = find_category_by_name
    erb :'/recipes/show_recipe'
  end

  get '/recipes/new' do
    if logged_in?
      @user = current_user
      erb :'recipes/create_recipe'
    else
      flash[:message] = "You must be signed in to add a recipe"
      redirect to '/signup'
    end
  end

  post '/recipes' do
    user = current_user
    @recipe = user.recipes.create(name: params["recipe"]["name"].downcase,
              instructions: params["recipe"]["instructions"],
              category_id: params["recipe"]["category_id"])
    params["ingredient"].each do |ingredient|
      @recipe.ingredients << Ingredient.create(
                      name: ingredient[:name].downcase,
                      amount: ingredient[:amount],
                      measurement_type: ingredient[:measurement_type].downcase)
    end
    if params[:file]
      @recipe.avatar = params[:file]
    end
    @recipe.save!
    redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
  end

  get '/recipes/:id/:slug/edit' do
    @recipe = find_recipe_by_id
    if !logged_in?
      flash[:message] = "You must be signed in to edit a recipe."
      redirect to '/signup'
    end
    @user = current_user
    if
      @user == @recipe.user
      erb :'recipes/edit_recipe'
    else
      flash[:message] = "You can only edit your recipes."
      redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
    end
  end

  post '/recipes/:id/:slug' do
    @recipe = find_recipe_by_id
    @recipe.update(name: params["recipe"]["name"].downcase,
                  user_id: session[:user_id],
                  instructions: params["recipe"]["instructions"],
                  category_id: params["recipe"]["category_id"])
    @recipe.ingredients.clear
    params["ingredient"].each do |ingredient|
      @recipe.ingredients << Ingredient.create(
                      name: ingredient[:name].downcase,
                      amount: ingredient[:amount],
                      measurement_type: ingredient[:measurement_type].downcase)
    end
    if params[:file]
      @recipe.avatar = params[:file]
    end
    @recipe.save!
    flash[:message] = "You have successfully editted your recipe."
    redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
  end

  get '/recipes/:id/:slug/makeit' do
    @recipe = find_recipe_by_id
    if !logged_in?
      flash[:message] = "You must be signed in to make a recipe your own."
      redirect to "/signup"
    end
    @user = current_user
    if
      @user == @recipe.user
      flash[:message] = "That recipe already belongs to you."
      redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
    else
      erb :'recipes/makeit_recipe'
    end
  end

  post '/recipes/makeit' do
    user = current_user
    @recipe = Recipe.create(
              name: params["recipe"]["name"].downcase,
              user_id: session[:user_id],
              instructions: params["recipe"]["instructions"],
              category_id: params["recipe"]["category_id"])
    params["ingredient"].each do |ingredient|
      @recipe.ingredients << Ingredient.create(
                      name: ingredient[:name].downcase,
                      amount: ingredient[:amount],
                      measurement_type: ingredient[:measurement_type].downcase)
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
    @user = current_user
    @recipe = find_recipe_by_id
    @recipe.liked_by @user
    redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
  end

  post '/recipes/:id/:slug/unlike' do
    @user = current_user
    @recipe = find_recipe_by_id
    @recipe.unliked_by @user
    redirect to "/recipes/#{@recipe.id}/#{@recipe.slug}"
  end

end
