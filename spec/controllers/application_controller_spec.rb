require 'spec_helper'


describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Cook This Way")
    end

    it 'has a link to view all recipes' do
      visit '/'
      expect(page).to have_link 'View All', href: '/recipes'
    end
  end
end
