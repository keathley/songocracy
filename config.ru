require "rubygems"
require "sinatra"

require File.expand_path "../app/app.rb", __FILE__

run Songocracy::App
