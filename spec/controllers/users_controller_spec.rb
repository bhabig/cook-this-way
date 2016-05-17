require 'spec_helper'

describe UsersController do

  describe "Signup Page" do
    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end
  end
end
