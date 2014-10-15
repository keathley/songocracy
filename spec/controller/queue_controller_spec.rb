require 'spec_helper'

module Songocracy
  describe App do
    describe "POST #queue" do
      context "when the track is found" do
        let(:id) { '12345' }

        before do
          @track = instance_double("Track")
          expect(Track).to receive(:find).with(id).and_return(@track)
        end

        it "should add the track to the queue" do
          expect(Queue).to receive(:add_song).with(@track)
          post '/queue', :id => id
        end

        it "should send a broadcast message" do
          expect(Faye).to receive(:broadcast)
          post '/queue', :id => id
        end
      end
    end

    describe "GET #queue" do
      it "should return the list of ids" do
        expect(Queue).to receive(:all).and_return(["1234", "4567"])
        get "/queue"
        body = JSON.parse(last_response.body)
        expect(body).to eq(["1234", "4567"])
      end
    end
  end
end
