module Songocracy
  class App < Sinatra::Base
    post "/queue" do
      Queue.add_song(params[:id])
      Faye.broadcast('/songs', {:id => params[:id]})
    end
  end
end
