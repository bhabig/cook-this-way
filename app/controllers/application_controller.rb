require './config/environment'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'will_paginate'
require 'will_paginate/active_record'
require 'will_paginate-bootstrap'
require 'will_paginate/collection'


class ApplicationController < Sinatra::Base
  include WillPaginate::Sinatra::Helpers

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    register Sinatra::Flash
    set :session_secret, ENV['SESSION_KEY'] || 'CAbo7bFkcNVh7MEjXPK)[agfkvRJv'
    set :raise_errors, true
    set :show_exceptions, true
  end

  # error do
  #   status 404
  #   erb :error
  # end
  #
  # error Sinatra::NotFound do
  #   status 404
  #   erb :error
  # end

  get '/' do
    if !session[:user_id]
      erb :index
    else
      @user = User.find(session[:user_id])
      erb :index
    end
  end

  get '/search' do
    @user = User.find(session[:user_id])
    erb :'/search/search'
  end

  get '/search/recipes' do
    @user = User.find(session[:user_id])
    @recipes = Recipe.all

    if params[:search]
      @recipes = []
      params[:search].split(/\s*,\s*/).each { |item| @recipes << Recipe.search(item) }
      @recipes.flatten!
    else
      @recipes = Recipe.all
    end
    erb :'/search/results'
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

  end


end
