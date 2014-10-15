require 'spec_helper'

module Songocracy
  describe App do
    describe "POST #queue" do
      it "should add the track to the queue" do
        expect(Queue).to receive(:add_song).with('12345')
        post '/queue', :id => '12345'
      end
    end
  end
end
