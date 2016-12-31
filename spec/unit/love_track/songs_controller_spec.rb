# frozen_string_literal: true

require 'spec_helper'
require 'love_track/songs_controller'

describe LoveTrack::SongsController do
  include Rack::Test::Methods

  def app
    LoveTrack::SongsController
  end

  it 'returns the current list of hosts' do
    get '/'
    expect(last_response).to be_ok

    response_body = last_response.body
    expect(response_body).to_not be_empty
  end
end
