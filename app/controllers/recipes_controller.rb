class RecipesController < ApplicationController

  get '/recipes' do
    erb :'/recipes/index'
  end
end
