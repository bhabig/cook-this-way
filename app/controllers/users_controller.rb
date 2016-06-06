class UsersController < ApplicationController

  get '/login' do
    if logged_in?
      flash[:message] = "You are already logged in."
      redirect to '/account'
    else
      erb :'users/login'
    end
  end

  get '/signup' do
    if logged_in?
      @user = current_user
    end
    erb :'/users/signup'
  end

  post '/signup' do
    if @user = User.find_by(:email => params[:email])
      flash[:message] = "That email is already in use."
      redirect to '/signup'
    else
      @user = User.create(:name => params[:name], :email => params[:email], :password => params[:password])
      session[:user_id] = @user.id
      redirect '/account'
    end
  end

  post "/login" do
    @user = User.find_by(:email => params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:message] = "You have successfully logged in!"
      redirect '/account'
    else
      flash[:message] = "Please check your credentials and try again."
      redirect '/login'
    end
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
