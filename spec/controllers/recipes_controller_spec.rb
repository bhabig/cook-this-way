require 'spec_helper'

describe RecipesController do

  describe "Recipes Page" do
    it 'loads the recipes page' do
      get '/recipes'
      expect(last_response.status).to eq(200)
    end
  end
end
