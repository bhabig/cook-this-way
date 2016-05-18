require 'spec_helper'


describe ApplicationController do

  before(:each) do
  #this replaces the actual omniauth query with what you will define as your mock below
  OmniAuth.config.test_mode = true
  # the symbol passed to mock_auth is the same as the name of the provider set up in the initializer
  OmniAuth.config.mock_auth[:facebook] = {
    :provider => 'facebook',
    :uid => '1234567',
    :credentials => {
      :token=> '3nkjnie'
    },
    :info => {
    :nickname => 'test',
    :email => 'info@gmail.com',
    :name => 'Test User',
    :first_name => 'Test',
    :last_name => 'User',
    :location => 'California',
    :verified => true
    }.stringify_keys!
  }.stringify_keys!
#this is what sets the auth failure
OmniAuth.config.on_failure = Proc.new { |env|
   OmniAuth::FailureEndpoint.new(env).redirect_to_failure
 }
end

  describe "Homepage" do

    it 'has a link to sign in with Facebook' do
      visit '/'
      expect(page).to have_link 'Sign in with Facebook', href: '/auth/facebook'
    end

    scenario "Login button should log in" do
      visit '/'
      click_on 'Sign in with Facebook'
      expect(page).to have_content('Sign Out')
    end

  end

end
