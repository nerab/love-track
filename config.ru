# frozen_string_literal: true
$LOAD_PATH.unshift File.join(__dir__, 'lib')

require 'love_track/songs_controller'
# require 'love_track/love_controller'

run Rack::URLMap.new(
  '/songs' => LoveTrack::SongsController,
  #  '/love' => LoveTrack::LoveController,
)
