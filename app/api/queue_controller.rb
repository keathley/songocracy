module Songocracy
  class App < Sinatra::Base
    post "/queue" do
      Queue.add_song(params[:id])
    end
  end
end
