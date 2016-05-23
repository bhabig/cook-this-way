ENV['SINATRA_ENV'] ||= "development"
require 'bundler/setup'

Bundler.require(:default, ENV['SINATRA_ENV'])

configure :development do
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)
end

configure :production do
 db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')

 ActiveRecord::Base.establish_connection(
   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
   :host     => db.host,
   :username => db.user,
   :password => db.password,
   :database => db.path[1..-1],
   :encoding => 'utf8'
 )
end

require_all 'app'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
CarrierWave.configure do |config|
    config.root = ApplicationController.public_folder
    config.fog_credentials = {
    :provider              => 'AWS',                     # required
    :aws_access_key_id     => ENV['AWS_S3_ACCESS_KEY'],  # required
    :aws_secret_access_key => ENV['AWS_S3_KEY_ID'],      # required
    :region                => ENV['AWS_S3_REGION']      # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = ENV['AWS_S3_BUCKET']        # required
  config.fog_public     = true                       # optional, defaults to true
  end
