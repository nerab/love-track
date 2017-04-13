# frozen_string_literal: true

require 'slack-notifier'

module LoveTrack
  class Notifier
    def initialize(url)
      @slack = Slack::Notifier.new(url) do
        defaults username: 'LoveTrack'
      end
    end

    def notify(msg)
      @slack.ping(msg, link_names: 1)
    end
  end
end
