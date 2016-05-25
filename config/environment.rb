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

ActiveRecord::Base.raise_in_transactional_callbacks = true

require_all 'app'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
CarrierWave.configure do |config|
config.storage    = :aws
config.aws_bucket = 'ctw-kbjwgqjqfzubu'
config.aws_acl    = 'public-read'

# The maximum period for authenticated_urls is only 7 days.
config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

# Set custom options such as cache control to leverage browser caching
config.aws_attributes = {
  expires: 1.week.from_now.httpdate,
  cache_control: 'max-age=604800'
}

config.aws_credentials = {
  access_key_id:     ENV.fetch('AWS_S3_ACCESS_KEY'),
  secret_access_key: ENV.fetch('AWS_S3_KEY_ID'),
  region:            ENV.fetch('AWS_S3_REGION') # Required
}
end
