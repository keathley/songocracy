require "json"
require "plaything"
require "logger"
require "bundler/setup"
require "spotify"
require "io/console"
require 'redis'

require './lib/redis'
require './lib/player/frame_reader'
require './lib/player/session_callbacks'
require './lib/player/log_formatter'

Thread.abort_on_exception = true

module Player

  APP_KEY_FILE = File.expand_path('../spotify_appkey.key', __FILE__)

  DEFAULT_CONFIG = {
    api_version: Spotify::API_VERSION.to_i,
    application_key: File.binread(APP_KEY_FILE),
    cache_location: ".spotify/",
    settings_location: ".spotify/",
    user_agent: "spotify for ruby",
    callbacks: Spotify::SessionCallbacks.new
  }

  def self.logger
    @logger ||= Logger.new(STDOUT)
    @logger.level = Logger::INFO
    @logger.formatter = LogFormatter.new
    @logger
  end

  def self.plaything
    @plaything ||= Plaything.new
  end

  def self.callbacks
    @callbacks ||= SessionCallbacks.new(plaything, logger)
  end

  # Main entry point for player
  # Sets up the configuration and session and then starts playback
  # @return [void]
  def self.play!
    DEFAULT_CONFIG[:callbacks] = Spotify::SessionCallbacks.new(callbacks.hash)
    session = initialize_spotify!(DEFAULT_CONFIG)
    play_loop(session)
  end

  # Creates the initial spotify session
  # This session also encompasses what happens when the script exits
  # @param config [Hash] the configuration hash
  # @return [Spotify:Session] the spotify session
  def self.initialize_spotify!(config)
    error, session = Spotify.session_create(config)
    raise Spotify::Error.new(error) if error

    if username = Spotify.session_remembered_user(session)
      logger.info "Using remembered login for: #{username}."
      Spotify.try(:session_relogin, session)
    else
      username = prompt("Spotify username, or Facebook e-mail")
      password = $stdin.noecho {
        prompt("Spotify password, or Facebook password")
      }

      logger.info "Attempting login with #{username}."
      Spotify.try(:session_login, session, username, password, true, nil)
    end

    logger.info "Log in requested. Waiting forever until logged in."
    poll(session) {
      Spotify.session_connectionstate(session) == :logged_in
    }

    at_exit do
      logger.info "Logging out."
      Spotify.session_logout(session)
      poll(session) {
        Spotify.session_connectionstate(session) != :logged_in
      }
    end

    session
  end

  # The main loop for playing songs.  It loops, pulling song ids from redis
  # and playing them.  If there is nothing in redis then it blocks until it can
  # @param session [Spotify::Session] the spotify session
  # @return [void]
  def self.play_loop(session)
    logger.info "Playing tracks"
    loop do
      play_track(session, "spotify:track:5OyurLkQVrXM7I33eiF696")
      play_track(session, "spotify:track:3fxW8hal5spPoqA1gcChgx")
    end
    logger.info "Done Playing tracks"
  end


  # libspotify supports callbacks, but they are not useful for waiting on
  # operations (how they fire can be strange at times, and sometimes they
  # might not fire at all). As a result, polling is the way to go.
  def self.poll(session, idle_time = 0.05)
    until yield
      print "."
      process_events(session)
      sleep(idle_time)
    end
  end

  # Process libspotify events once.
  def self.process_events(session)
    Spotify.session_process_events(session)
  end

  # Play a specified track
  # Loads a track and plays it.  Once the track has ended it then unloads
  # the track.  This is necessary in order to play new track in the future.
  def self.play_track(session, uri)
    track = get_track(uri)
    load_and_play_track(session, track)
    clean_up_track(session)
  end

  def self.get_track(uri)
    Spotify.link_as_track(Spotify.link_create_from_string(uri))
  end

  # Loads a track and then plays it
  # It needs to stop playback before it loads the track in order to fix a bug
  # with libspotify
  # @param session [Spotify::Session] the current session
  # @param track [Spotify::Track] the desired track
  # @return [void]
  def self.load_and_play_track(session, track)
    poll(session) { Spotify.track_is_loaded(track) }
    Spotify.try(:session_player_play, session, false)
    Spotify.try(:session_player_load, session, track)
    Spotify.try(:session_player_play, session, true)
    logger.info "Track is playing"
    poll(session) { callbacks.end_of_track }
    logger.info "Track has ended"
  end

  def self.clean_up_track(session)
    Spotify.try(:session_player_unload, session)
    logger.info "Unloading track"
    callbacks.end_of_track = false
  end

  # Ask the user for input with a prompt explaining what kind of input.
  def self.prompt(message, default = nil)
    if default
      print "\n#{message} [#{default}]: "
      input = gets.chomp

      if input.empty?
        default
      else
        input
      end
    else
      print "\n#{message}: "
      gets.chomp
    end
  end
end
