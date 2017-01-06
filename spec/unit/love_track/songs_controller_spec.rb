# frozen_string_literal: true

require 'spec_helper'
require 'love_track/songs_controller'
require 'webmock/rspec'

WebMock.disable_net_connect!

describe LoveTrack::SongsController do
  include Rack::Test::Methods

  def app
    LoveTrack::SongsController
  end

  let(:body) {
    { 'frontmod' => [{ 'title' => 'Never gonna give you up', 'artist' => { 'name' => 'Rick Astley' }, }] }.to_json
  }

  before do
    stub_request(
      :get,
      'http://www.swr3.de/export/json/-/id=202234/gp1=1/wi3aps/index.json'
    ).to_return(body: body)
  end

  it 'returns the current song' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Rick Astley: Never gonna give you up$/)
  end

  context 'expressing love for a song' do
    let(:user) { 'test-user' }
    let(:notifier) { instance_double('Notifier') }

    before do
      allow(notifier).to receive(:notify)
      subject.settings.notifier = notifier
    end

    it 'fails without basic auth' do
      post '/'
      expect(last_response.status).to eq(401)
    end

    it 'fails without basic auth username' do
      basic_authorize('', 'ignored')
      post '/'
      expect(last_response.status).to eq(401)
    end

    context 'with basic auth' do
      before do
        basic_authorize(user, 'ignored')
      end

      it 'returns 201' do
        post '/'
        expect(last_response.status).to eq(201)
      end

      it 'returns a message that contains the loved song' do
        post '/'
        expect(last_response.body).to match(/liebt den Song 'Never gonna give you up'/)
      end

      it 'returns a message that contains the authorized user' do
        post '/'
        expect(last_response.body).to match(/#{user} liebt den Song/)
      end

      it 'sends a slack notification with the current song' do
        expect(notifier).to receive(:notify).with("@#{user} liebt den Song 'Never gonna give you up' von Rick Astley")
        post('/')
      end
    end
  end
end
