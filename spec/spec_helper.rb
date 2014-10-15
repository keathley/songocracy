require 'rack/test'

require File.expand_path '../../app/app.rb', __FILE__

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  include Rack::Test::Methods

  def app
    # Songocracy::App
    described_class
  end
end
