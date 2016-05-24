require 'spec_helper'



describe ApplicationController do

  describe "Facebook Integration" do
    it 'has a link to sign in with Facebook' do
      visit '/'
      expect(page).to have_link 'Sign in with Facebook', href: '/auth/facebook'
    end
  end

  it 'has a login in with Facebook link' do
    visit '/'
    expect(page).to have_link 'Sign in with Facebook', href: '/auth/facebook'
  end

  describe 'Logging in with Facebook' do
    before(:each) do
      facebook_login_setup
      visit '/auth/facebook'
      @user = User.last
    end

    it "is successful" do
      expect(page).to have_content('You have successfully signed in!')
      expect(page).to have_content("Hello, #{@user.name}!")
    end

  end

end
