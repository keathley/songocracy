module Songocracy
  describe Queue do
    describe ".add_track" do
      it "should add the uuid to the internal queue" do
        expect($redis).to receive(:zadd).with('track_list', 1, '123abc')
        Queue.add_song('123abc')
      end
    end
  end
end
