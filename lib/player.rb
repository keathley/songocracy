require "json"
require "plaything"
require "logger"
require "bundler/setup"
require "spotify"
require "io/console"

require_relative 'player/frame_reader'
require_relative 'player/session_callbacks'
require_relative 'player/log_formatter'

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

  def self.play!
    DEFAULT_CONFIG[:callbacks] = Spotify::SessionCallbacks.new(callbacks.hash)

    session = initialize_spotify!(DEFAULT_CONFIG)

    play_track(session, "spotify:track:666Gq86pwKtAJcLB9Jg9aF")
    # play_track(session, "spotify:track:2j6oDxFsF0Fjd4rDhFQCsL")

    logger.info "Playing track until end. Use ^C to exit."
    poll(session) { callbacks.end_of_track? }
  end

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

  def self.play_track(session, uri)
    link = Spotify.link_create_from_string(uri)
    track = Spotify.link_as_track(link)
    poll(session) { Spotify.track_is_loaded(track) }

    # Pause before we load a new track. Fixes a quirk in libspotify.
    Spotify.try(:session_player_play, session, false)
    Spotify.try(:session_player_load, session, track)
    Spotify.try(:session_player_play, session, true)
  end
end
