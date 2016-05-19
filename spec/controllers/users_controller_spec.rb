require 'spec_helper'

describe UsersController do

    it 'allows the user to log out' do
      visit '/signout'
      expect(page).to have_content('You have successfully signed out!')
    end

    describe "Signup Page" do
      it 'has a signup page' do
        get '/signup'
        expect(last_response.status).to eq(200)
      end

      it 'asks the user to signup' do
        visit '/signup'
        expect(page).to have_content('Sign in to access all content')
      end
    end

    describe "User Account Page" do
      it 'greets them by name' do
        
      end
    end
end
