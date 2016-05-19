class RecipesController < ApplicationController

  get '/recipes' do
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
    erb :'/recipes/index'
  end
end
