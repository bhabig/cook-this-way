require 'spec_helper'


describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Cook This Way")
    end
  end

  describe "Sign up/Log in" do
    it 'has a link to sign up' do
      visit '/'
      expect(page).to have_link 'Sign up', href: '/signup'
    end
  end

  it 'has a link to log in' do
    visit '/'
    expect(page).to have_link 'Log in', href: '/login'
  end
end
