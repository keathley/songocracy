module Songocracy
  class Queue
    TRACK_LIST = 'track_list'

    def self.add_song(track, score=1)
      $redis.zadd(TRACK_LIST, score, track.to_json)
    end

    def self.all
      tracks = $redis.zrevrange(TRACK_LIST, 0, -1)
      tracks.map { |track| JSON.parse(track) }
    end
  end
end
