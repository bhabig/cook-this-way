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
        expect(page).to have_content('Sign up to access all these great features!')
      end
    end

    describe 'User Account Page' do
      before(:each) do
        create_new_user
        visit '/login'
        fill_in 'email', :with => 'steve.rogers@example.com'
        fill_in 'password', :with => 'password'
        click_button 'Log in'
      end

      it "greets the user" do
        expect(page).to have_content('Hello, Steve Rogers!')
      end

      it "lists the user's recipes" do
        expect(page).to have_content('Your recipes')
      end
    end
end
