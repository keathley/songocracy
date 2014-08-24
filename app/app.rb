require 'sinatra/base'

module Songocracy
  class App < Sinatra::Application

    get "/hello" do
      return "World"
    end

  end
end
