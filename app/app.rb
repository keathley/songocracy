require 'bundler/setup'
require 'sinatra/base'
require 'json'
require 'redis'
require 'net/http'

require './config/redis'
require_relative 'models/queue'
require_relative 'models/faye'

require_relative 'api/queue_controller'

module Songocracy
  class App < Sinatra::Base
    set :root, File.dirname(__FILE__)
    set :public_folder, Proc.new { File.join(root, "../public") }
    set :sessions, true
    set :static, true
    set :logging, true

    get "/" do
      erb :index
    end
  end
end
