module Songocracy
  class Track
    attr_reader :name, :artist, :images

    def initialize(opts={})
      @name   = opts.fetch(:name)
      @artist = opts.fetch(:artist)
      @images = opts.fetch(:images)
    end

    def self.find(id)
      r_track = find_track_with_rspotify(id)
      new(
        name:   r_track.name,
        artist: r_track.artists.first.name,
        images: r_track.album.images
      )
    end

    def self.find_track_with_rspotify(id)
      RSpotify::Track.find(id)
    end
    private_class_method :find_track_with_rspotify
  end
end