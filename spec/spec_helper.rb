require 'rack/test'
require 'vcr'

require File.expand_path '../../app/app.rb', __FILE__

ENV['RACK_ENV'] = 'test'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  include Rack::Test::Methods

  def app
    # Songocracy::App
    described_class
  end
end
