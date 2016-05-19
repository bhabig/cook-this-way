require 'spec_helper'


describe ApplicationController do

  describe "Facebook Integration" do
    it 'has a link to sign in with Facebook' do
      visit '/'
      expect(page).to have_link 'Sign in with Facebook', href: '/auth/facebook'
    end
  end

def facebook_login_setup
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = nil
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    :provider => 'facebook',
    :uid => '1234567',
    :info => {
      :email => 'joe@bloggs.com',
      :name => 'Joe Bloggs',
      :first_name => 'Joe',
      :last_name => 'Bloggs',
      :image => 'http://graph.facebook.com/1234567/picture?type=square',
      :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
      :location => 'Palo Alto, California',
      :verified => true
    },
    :credentials => {
      :token => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
      :expires_at => 1321747205, # when the access token expires (it always will)
      :expires => true # this will always be true
    },
    :extra => {
      :raw_info => {
        :id => '1234567',
        :name => 'Joe Bloggs',
        :first_name => 'Joe',
        :last_name => 'Bloggs',
        :link => 'http://www.facebook.com/jbloggs',
        :username => 'jbloggs',
        :location => { :id => '123456789', :name => 'Palo Alto, California' },
        :gender => 'male',
        :email => 'joe@bloggs.com',
        :timezone => -8,
        :locale => 'en_US',
        :verified => true,
        :updated_time => '2011-11-11T06:21:03+0000'
      }
    }
  })
end

  it 'has a login in with Facebook link' do
    visit '/'
    expect(page).to have_link 'Sign in with Facebook', href: '/auth/facebook'
  end

  describe 'Logging in with Facebook' do
    before(:each) do
      facebook_login_setup
      visit '/auth/facebook'
    end

    it "is successful" do
      expect(page).to have_content('You have successfully signed in!')
      expect(page).to have_content('Account Page')
    end

  end

end
