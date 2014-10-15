module Songocracy
  class App < Sinatra::Base
    post "/queue" do
      @track = Track.find(params[:id])

      unless @track.nil?
        Queue.add_song(@track)
        Faye.broadcast('/songs', {:id => params[:id]})
      end
    end

    get "/queue" do
      content_type :json

      Queue.all.to_json
    end
  end
end
