# frozen_string_literal: true

require_relative 'docker/image'
require_relative 'docker/container'
require_relative 'docker/config'
require 'English'

namespace :docker do
  def container
    @container ||= Docker::Container.new(config.container_name)
  end

  def image
    @image ||= Docker::Image.new(config.image_name)
  end

  def staging
    config.staging
  end

  def production
    config.production
  end

  def config
    @config ||= Docker::Config.new(Pathname(Rake.application.original_dir) / 'docker.yml')
  end

  desc "Stop the #{container}"
  task :stop do
    container.stop if container.running?
  end

  desc "Remove the #{container}"
  task rm: [:stop] do
    container.rm if container.exist?
  end

  desc "Build the #{image}"
  task :build do |t|
    sh "docker build -t #{image.name} ."
  end

  desc "Run the #{image} as new #{container}"
  task run: [:build] do
    begin
      image.run(name: container.name, detach: true, publish: config.publish)
    rescue
      warn "Error running #{image}: #{$ERROR_INFO}"
    end
  end

  desc "Re-build and run the #{container}"
  task restart: [:build, :rm, :run]

  desc "Promote the #{image} from #{staging} to #{production}"
  task :promote do
    size = `docker $(docker-machine config #{staging}) images --format \"{{.Size}}\" #{image.name}:latest`.chomp
    puts "Promoting image '#{image.name}:latest' (#{size}) from #{staging} to #{production}"
    sh "docker $(docker-machine config #{staging.name}) save #{image.name}:latest | pv | docker $(docker-machine config #{production.name}) load"
  end
end
