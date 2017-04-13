# frozen_string_literal: true

require 'slack-notifier'

module LoveTrack
  class ConsoleNotifier
    def notify(msg)
      warn(msg)
    end
  end
end
