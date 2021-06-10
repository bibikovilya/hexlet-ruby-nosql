require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'redis'
  gem 'hiredis'
  gem 'pry'
end

require 'json'
require 'hiredis/reader'

redis = Redis.new
redis.setex('exp', 10, 'expired value')
redis.set(:array, [1,2,3].to_json)

hiredis = Hiredis::Connection.new
hiredis.connect('localhost', 6379)

hiredis.write ["SET", "speed", "awesome"]
hiredis.write ["GET", "speed"]
# hiredis.read

binding.pry
