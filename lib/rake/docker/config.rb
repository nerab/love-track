# frozen_string_literal: true
require_relative './stage' unless defined?('Docker::Stage')

require 'pathname'
require 'yaml'

module Docker
  Stage = Struct.new(:name) do
    def to_s
      "#{self.class.name.split('::').last.downcase} '#{name}'"
    end
  end

  class Config
    def initialize(config_file)
      @config_file = Pathname(config_file)
      @config = YAML.load_file(config_file)
    end

    def image_name
      if @config && @config['image_name']
        @config['image_name']
      else
        @config_file.dirname.basename.to_s
      end
    end

    def container_name
      if @config && @config['container_name']
        @config['container_name']
      else
        image_name.split('/').last
      end
    end

    def publish
      if @config && @config['publish']
        @config['publish']
      else
        {}
      end
    end

    def staging
      Stage.new(
        if @config && @config['staging']
          @config['staging']
        else
          'staging'
        end
      )
    end

    def production
      Stage.new(
        if @config && @config['production']
          @config['production']
        else
          'production'
        end
      )
    end
  end
end
