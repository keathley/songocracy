require 'faye'
server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
run server
