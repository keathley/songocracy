module Songocracy
  describe Queue do
    describe ".add_track" do
      it "should add the uuid to the internal queue" do
        track = instance_double("Track")
        expect($redis).to receive(:zadd).with('track_list', 1, track.to_json)
        Queue.add_song(track)
      end
    end

    describe ".all" do
      it "should return all songs in queue" do
        expect($redis).to receive(:zrevrange).with('track_list', 0, -1)
          .and_return(['1234', '4567'])
        expect(Queue.all).to eq(['1234', '4567'])
      end
    end
  end
end
