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
require 'active_support/inflector'

class ApplicationController < Sinatra::Base
  include WillPaginate::Sinatra::Helpers

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    register Sinatra::Flash
    set :session_secret, ENV['SESSION_KEY'] || 'CAbo7bFkcNVh7MEjXPK)[agfkvRJv'
     if ENV['RACK_ENV'] == 'development'
      set :raise_errors, true
      set :show_exceptions, true
    else
      set :raise_errors, false
      set :show_exceptions, false
    end
  end
  if ENV['RACK_ENV'] != 'development'
    error do
      if !logged_in?
        status 404
        erb :error
      else
        @user = current_user
        status 404
        erb :error
      end
    end

    error Sinatra::NotFound do
      if !logged_in?
        status 404
        erb :error
      else
        @user = current_user
        status 404
        erb :error
      end
    end
  end

  get '/' do
    if !logged_in?
      erb :index
    else
      @user = current_user
      erb :index
    end
  end

  get '/search' do
    if !logged_in?
      erb :'/search/search'
    else
      @user = current_user
      erb :'/search/search'
    end
  end

  get '/search/recipes' do
    if logged_in?
      @user = current_user
    end
    @recipes = Recipe.all
    if params[:search]
      @recipes = []
      params[:search].downcase.split(/\s*,\s*/).each { |item| @recipes << Recipe.search(item) }
      @recipes.flatten!
      @recipes_counter = params[:search].downcase.split(/\s*,\s*/)
    else
      @recipes = Recipe.all
    end
    erb :'/search/recipes_results'
  end

  get '/search/ingredients' do
    if logged_in?
      @user = current_user
    end
    @ingredients = Ingredient.all
    @recipes = Recipe.all
    if params[:search]
      @ingredients = []
      params[:search].downcase.split(/\s*,\s*/).each { |ingredient| @ingredients << Ingredient.search(ingredient) }
      @ingredients.flatten!
      if @ingredients.count > 0
        @ingredients_counter = @ingredients.uniq { |ingredient| ingredient.name }
    else
        @ingredients_counter = params[:search].downcase.split(/\s*,\s*/)
      end
      @recipes = []
      @ingredients.each { |ingredient| @recipes << ingredient.recipes }
      @recipes.flatten!
      @recipes = @recipes.uniq { |recipe| recipe.id }
      @ingredients.flatten!
    else
      @ingredients = Ingredient.all
    end
    erb :'/search/ingredients_results'
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def set_session
      session[:user_id] = @user.id
    end

    def find_user_by_id
      User.find_by_id(params[:id])
    end

    def find_user_by_email
      User.find_by_email(params[:email])
    end

    def find_recipe_by_id
      Recipe.find_by_id(params[:id])
    end

    def find_category_by_slug
      Category.find_by_slug(params[:slug])
    end

    def find_category_by_name
      Category.find_by_name(@recipe.category.name)
    end

  end


end
