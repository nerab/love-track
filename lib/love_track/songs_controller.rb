# frozen_string_literal: true
require 'sinatra/base'

require 'swr3_now_playing/loader'
require 'swr3_now_playing/mapper'
require 'slack-notifier'

module LoveTrack
  class SongsController < Sinatra::Base
    set :slack, Slack::Notifier.new(ENV.fetch('SLACK_WEBHOOK_URL'))

    get '/' do
      begin
        json = SWR3::NowPlaying::Loader.load
        song = SWR3::NowPlaying::Mapper.map(json)

        settings.slack.username = 'LoveTrack'
        settings.slack.ping "@fpu liebt den Song '#{song.title}' von #{song.artist}"

        "#{Time.new} - #{song}"
      rescue
        "Sorry; #{$!.message}"
      end
    end
  end
end
