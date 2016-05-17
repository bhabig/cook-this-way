require 'spec_helper'

describe RecipesController do

  describe "User Can View All Recipes" do
    it 'loads the recipe index' do
      get '/recipes'
      expect(last_response.status).to eq(200)
    end
  end
end
