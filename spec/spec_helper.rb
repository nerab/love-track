# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, '..', 'lib')

ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'rspec/collection_matchers'

require 'pry'
require 'pry-byebug'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
