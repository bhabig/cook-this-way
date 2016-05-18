# require 'dotenv' # Breaks Heroku
# Dotenv.load
require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::Session::Cookie, :secret => ENV['RACK_SESSION']
use OmniAuth::Builder do
  provider :facebook, ENV['FB_APP_ID'], ENV['FB_APP_SECRET']
end

use SessionsController
use RecipesController
use UsersController
run ApplicationController
