require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::Session::Cookie, :secret => 'A{c8KudHWXo6EphvcCL>LNJtXWpHCe'
use OmniAuth::Builder do
  provider :facebook, ENV['APP_ID'], ENV['APP_SECRET'], :scope => 'email,read_stream'
end

use RecipesController
use UsersController
run ApplicationController
