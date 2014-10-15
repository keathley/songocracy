source 'https://rubygems.org/'

gem 'spotify', :git => 'https://github.com/spyc3r/spotify.git'
gem "plaything", "~> 1.1"
gem 'redis'
gem 'unicorn'
gem 'sinatra'

gem 'faye'
gem 'puma' # Needed for Faye

group :development, :test do
  gem 'foreman'
  gem 'rspec', "~> 3.1.0"
  gem 'shotgun'
end

group :test do
  gem 'rack-test'
end

group :development, :documentation do
  gem 'yard'
end
