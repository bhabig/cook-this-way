require 'sinatra/base'

class UsersController < ApplicationController
  enable :sessions

  get '/auth/:provider/callback' do
    @user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = @user.id
    redirect to '/recipes'
  end

  get '/auth/failure' do
    redirect to '/'
  end

  get '/signout' do
    session[:user_id] = nil
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
end
