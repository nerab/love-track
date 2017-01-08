# frozen_string_literal: true
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rake/clean'
load 'lib/rake/docker.rake'

task default: ['spec:ci']

namespace :spec do
  desc 'Run ci tests'
  task ci: ['rubocop:auto_correct', :unit]

  %w(unit system acceptance).each do |type|
    desc "Run #{type} tests"
    RSpec::Core::RakeTask.new(type) do |t|
      t.pattern = "spec/#{type}/**/*_spec.rb"
    end
  end
end

RuboCop::RakeTask.new
