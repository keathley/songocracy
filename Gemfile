source 'https://rubygems.org/'

gem 'spotify', :git => 'https://github.com/spyc3r/spotify.git'
gem "plaything", "~> 1.1"
gem 'redis'
gem 'unicorn'
gem 'sinatra'
gem 'rspotify'

gem 'faye'
gem 'puma' # Needed for Faye

gem 'pry'

group :development, :test do
  gem 'foreman'
  gem 'rspec', "~> 3.1.0"
  gem 'shotgun'
  gem 'vcr'
  gem 'webmock'
end

group :test do
  gem 'rack-test'
end

group :development, :documentation do
  gem 'yard'
end
