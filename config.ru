require 'dotenv' # Breaks Heroku
Dotenv.load
require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::Session::Cookie, :secret => ENV['SESSION_KEY']
use OmniAuth::Builder do
  provider :facebook, ENV['FB_APP_ID'], ENV['FB_APP_SECRET'], :scope => 'email'
end

use RecipesController
use UsersController
run ApplicationController
