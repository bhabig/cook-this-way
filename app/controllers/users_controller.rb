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
    if current_user
      @user = current_user
      erb :'/users/account'
    else
      redirect to '/'
    end
  end

  get '/signup' do
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
    erb :'/users/signup'
  end

  get '/users/:id/recipes' do
    if !session[:user_id]
      flash[:message] = "You must be signed in to view a user's recipes page."
      erb :'/users/signup'
    else
      @user = User.find(session[:user_id])
      @view_user = User.find_by_id(params[:id])
      @recipes = @view_user.recipes
      erb :'/users/user_recipes'
    end
  end

  get '/users/:id/favorites' do
    if !session[:user_id]
      flash[:message] = "You must be signed in to view a user's recipes page."
      erb :'/users/signup'
    else
      @user = User.find(session[:user_id])
      @view_user = User.find_by_id(params[:id])
      erb :'/users/user_favorites'
    end
  end

end
