class RecipesController < ApplicationController

  get '/recipes' do
    if !session[:user_id]
      redirect to '/'
    else
      @user = User.find(session[:user_id])
      erb :'/recipes/index'
    end
  end
end
