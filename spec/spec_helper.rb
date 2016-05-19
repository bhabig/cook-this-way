ENV["SINATRA_ENV"] = "test"


require_relative '../config/environment'
require 'rack/test'
require 'capybara/rspec'
require 'capybara/dsl'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate SINATRA_ENV=test` to resolve the issue.'
end

ActiveRecord::Base.logger = nil

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include Rack::Test::Methods
  config.include Capybara::DSL
  DatabaseCleaner.strategy = :truncation

  config.before do
    DatabaseCleaner.clean
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.order = 'default'
end


def app
  Rack::Builder.parse_file('config.ru').first
end

Capybara.app = app

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
