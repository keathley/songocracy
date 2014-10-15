module Songocracy
  class Queue
    TRACK_LIST = 'track_list'

    def self.add_song(track, score=1)
      $redis.zadd(TRACK_LIST, score, track)
    end
  end
end
