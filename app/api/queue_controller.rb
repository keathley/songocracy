module Songocracy
  class App < Sinatra::Base
    post "/queue" do
      content_type :json

      @track = Track.find(params[:id])

      unless @track.nil?
        valid = Queue.add_song(@track)
        Faye.broadcast('/songs', @track) if valid
      end
    end

    get "/queue" do
      content_type :json

      Queue.all.to_json
    end
  end
end
