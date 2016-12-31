# frozen_string_literal: true
require 'sinatra/base'

module LoveTrack
  class SongsController < Sinatra::Base
    get '/' do
      'there will be lots of songs'
    end
  end
end
