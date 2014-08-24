require "rubygems"
require "sinatra"

require File.expand_path "./app/app.rb"
run Songocracy::App
