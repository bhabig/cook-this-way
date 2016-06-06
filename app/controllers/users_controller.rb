class UsersController < ApplicationController

  get '/auth/:provider/callback' do
    @user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = @user.id
    flash[:message] = "You have successfully signed in!"
    redirect to '/account'
  end

  get '/auth/failure' do
    redirect to '/'
  end

  get '/signout' do
    session[:user_id] = nil
    flash[:message] = "You have successfully signed out!"
    redirect to '/'
  end

  get '/account' do
    if logged_in?
      @user = current_user
      erb :'/users/account'
    else
      redirect to '/'
    end
  end

  get '/signup' do
    if logged_in?
      @user = current_user
    end
    erb :'/users/signup'
  end

  get '/users/:id/recipes' do
    if !logged_in?
      flash[:message] = "You must be signed in to view a user's recipes page."
      redirect to '/signup'
    else
      @user = current_user
      @view_user = find_user_by_id
      @recipes = @view_user.recipes
      erb :'/users/user_recipes'
    end
  end

  get '/users/:id/favorites' do
    if !logged_in?
      flash[:message] = "You must be signed in to view a user's recipes page."
      erb :'/users/signup'
    else
      @user = current_user
      @view_user = find_user_by_id
      erb :'/users/user_favorites'
    end
  end

end
