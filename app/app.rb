require 'bundler/setup'
require 'sinatra/base'
require 'json'

require 'api/tracks'

module Songocracy
  class App < Sinatra::Application
    set :sessions, true
    set :static, true

    get "/" do
      File.read(File.join('public', 'index.html'))
    end
  end
end
