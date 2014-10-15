require 'bundler/setup'
require 'sinatra/base'
require 'json'
require 'redis'

require './config/redis'
require_relative 'models/queue'

require_relative 'api/queue_controller'

module Songocracy
  class App < Sinatra::Base
    set :sessions, true
    set :static, true
    set :logging, true

    get "/" do
      File.read(File.join('public', 'index.html'))
    end
  end
end
