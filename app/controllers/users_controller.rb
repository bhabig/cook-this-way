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
    if session[:user_id]
      @user = User.find(session[:user_id])
      erb :'/users/account'
    else
      redirect to '/'
    end
  end

  get '/signup' do
    flash[:message] = "You must be signed in to access that."
    erb :'/users/call_to_sign_up'
  end
end
