require 'spec_helper'

module Songocracy
  describe Track do
    describe ".find" do
      it "should return a new instance of track", :vcr do
        id = "3fPSHjVO4iwwGEhHvTwlNb"
        name = "Try Honesty"
        artist = "Billy Talent"

        track = Track.find(id)
        expect(track.name).to eq(name)
        expect(track.artist).to eq(artist)
        expect(track.images).to_not be_empty
      end
    end
  end
end
