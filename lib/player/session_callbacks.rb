# Global callback procs.
#
# They are global variables to protect from ever being garbage collected.
#
# You must not allow the callbacks to ever be garbage collected, or libspotify
# will hold information about callbacks that no longer exist, and crash upon
# calling the first missing callback. This is *very* important!
module Player
  class SessionCallbacks

    def initialize(plaything, logger)
      @plaything = plaything
      @logger = logger
      @end_of_track = false
    end

    def hash
      {
        log_message: proc do |session, message|
          @logger.info("session (log message)") { message }
        end,

        logged_in: proc do |session, error|
          @logger.debug("session (logged in)") { Spotify::Error.explain(error) }
        end,

        logged_out: proc do |session|
          @logger.debug("session (logged out)") { "logged out!" }
        end,

        streaming_error: proc do |session, error|
          @logger.error("session (player)") {
            "streaming error %s" % Spotify::Error.explain(error)
          }
        end,

        start_playback: proc do |session|
          @logger.debug("session (player)") { "start playback" }
          @plaything.play
        end,

        stop_playback: proc do |session|
          @logger.debug("session (player)") { "stop playback" }
          @plaything.stop
        end,

        get_audio_buffer_stats: proc do |session, stats|
          stats[:samples] = @plaything.queue_size
          stats[:stutter] = @plaything.drops
          @logger.debug("session (player)") {
            "queue size [#{stats[:samples]}, #{stats[:stutter]}]"
          }
        end,

        music_delivery: proc do |session, format, frames, num_frames|
          if num_frames == 0
            @logger.debug("session (player)") {
              "music delivery audio discontuity"
            }
            @plaything.stop
            0
          else
            frames = FrameReader.new(
              format[:channels],
              format[:sample_type],
              num_frames,
              frames
            )
            consumed_frames = @plaything.stream(frames, format.to_h)
            @logger.debug("session (player)") {
              "music delivery #{consumed_frames} of #{num_frames}"
            }
            consumed_frames
          end
        end,

        end_of_track: proc do |session|
          @end_of_track = true
          @logger.debug("session (player)") { "end of track" }
          @plaything.stop
        end
      }
    end

    def end_of_track?
      @end_of_track
    end
  end
end
