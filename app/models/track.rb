module Songocracy
  class Track
    attr_reader :name, :artist, :images

    def initialize(opts={})
      @id     = opts.fetch(:id)
      @name   = opts.fetch(:name)
      @artist = opts.fetch(:artist)
      @images = opts.fetch(:images)
    end

    def to_json(*a)
      {
        id: @id,
        name: @name,
        artist: @artist,
        images: @images
      }.to_json(*a)
    end

    def self.find(token)
      r_track = find_track_with_rspotify(id_for(token))
      new(
        id:     r_track.id,
        name:   r_track.name,
        artist: r_track.artists.first.name,
        images: r_track.album.images
      )
    end

    def self.id_for(id_or_uuid)
      id_or_uuid.sub("spotify:track:", "")
    end

    def self.find_track_with_rspotify(id)
      RSpotify::Track.find(id)
    end
    private_class_method :find_track_with_rspotify
  end
end