# frozen_string_literal: true
require 'English'

module Docker
  class Image
    attr_reader :name

    def initialize(name)
      @name = name
    end

    # Runs the image and returns the resulting container
    def run(options)
      run_options = [
        !!options[:name]   ? "--name #{options[:name]}" : '',
        !!options[:detach] ? '--detach' : '',
        options[:publish].map { |from, to| "--publish #{from}:#{to}" },
      ].join(' ')

      `docker run #{run_options} #{name}`

      if $CHILD_STATUS.success?
        Container.new(options[:name])
      else
        raise "Could not run #{self}; see previous message for details."
      end
    end

    def to_s
      "#{self.class.name.split('::').last.downcase} '#{name}'"
    end
  end
end
