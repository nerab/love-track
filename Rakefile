# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rake/clean'
require 'yaml'

namespace :docker do
  def image_name
    config['services'].values.first['image']
  end

  def stages
    @stages ||= if File.exist?('docker-stages.yml')
                  YAML.load_file('docker-stages.yml')
                else
                  { 'staging' => 'staging', 'production' => 'production' }
                end
  end

  def config
    @config ||= YAML.load_file('docker-compose.yml')
  rescue Errno::ENOENT
    fail 'Could not load docker-compose.yml. Have a look at sample-docker-compose.yml for instance.'
  end

  desc "Promote the image from #{stages['staging']} to #{stages['production']}"
  task :promote do
    sh "docker $(docker-machine config #{stages['staging']}) save #{image_name}:latest | pv | docker $(docker-machine config #{stages['production']}) load"
  end
end

task default: ['spec:ci']

namespace :spec do
  desc 'Run ci tests'
  task ci: ['rubocop:auto_correct', :system]

  desc 'Run system tests'
  RSpec::Core::RakeTask.new(:system) do |t|
    t.pattern = 'spec/system/**/*_spec.rb'
  end
end

RuboCop::RakeTask.new
