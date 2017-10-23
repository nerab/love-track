# frozen_string_literal: true

require 'sinatra/base'
require 'English'

require 'swr3_now_playing/loader'
require 'swr3_now_playing/mapper'

require 'love_track/notifier'
require 'love_track/console_notifier'

module LoveTrack
  class SongsController < Sinatra::Base
    configure :development, :test do
      set :notifier, ConsoleNotifier.new
    end

    configure :production do
      set :notifier, Notifier.new(ENV.fetch('SLACK_WEBHOOK_URL'))
    end

    # rubocop:disable Lint/RescueWithoutErrorClass
    get '/' do
      begin
        "#{Time.new}: #{song}"
      rescue => e
        warn e.inspect
        [500, "Sorry; #{e.message}"]
      end
    end

    post '/' do
      protected!
      msg = "@#{@auth.username} liebt den Song '#{song.title}' von #{song.artist}"
      settings.notifier.notify(msg)
      status 201
      body msg
    end

    def song
      json = SWR3::NowPlaying::Loader.load
      SWR3::NowPlaying::SongMapper.map(json)
    end

    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && !@auth.credentials.first.empty?
    end
  end
end
