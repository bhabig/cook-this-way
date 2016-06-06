class UsersController < ApplicationController

  get '/signin' do
    erb :'users/signin'
  end

  get '/signup' do
    if logged_in?
      @user = current_user
    end
    erb :'/users/signup'
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
