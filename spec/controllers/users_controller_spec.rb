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

    describe 'User Account Page' do
      before(:each) do
        facebook_login_setup
        visit '/auth/facebook'
      end

      it "greets the user" do
        visit '/account'
        expect(page).to have_content('Welcome, Joe Bloggs!')
      end

      it "lists the user's recipes" do
        visit '/account'
        expect(page).to have_content('Your recipes')
      end
    end
end
