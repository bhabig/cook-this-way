source 'https://rubygems.org'

gem "sinatra"
gem 'activerecord', :require => 'active_record'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'sinatra-flash'
gem 'sinatra-redirect-with-flash'
gem 'require_all'
gem 'bcrypt'
gem 'thin'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'koala'

group :development do
 gem 'sqlite3'
 gem "tux"
 gem 'faker'
 gem 'pry'
 gem 'shotgun'
 gem 'dotenv'
end

group :production do
 gem 'pg'
end

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'rack-test'
  gem 'database_cleaner', git: 'https://github.com/bmabey/database_cleaner.git'
end
