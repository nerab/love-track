# frozen_string_literal: true
namespace :docker do
  Image = Struct.new(:name) do
    def run(options)
      run_options = [
        !!options[:detach] ? '--detach' : '',
        options[:publish].map { |from, to| "--publish #{from}:#{to}" },
        "--name #{options[:name]}",
      ].join(' ')

      `docker run #{run_options} #{image.name}`
    end

    def to_s
      "#{self.class.name.downcase} #{name}"
    end
  end

  Container = Struct.new(:name) do
    def running?
      `docker ps --filter "name=#{name}" --filter "status=running" --format "{{.ID}}"`.lines.any?
    end

    def exist?
      `docker ps --all --filter "name=#{name}" --format "{{.ID}}"`.lines.any?
    end

    def stop
      `docker stop #{name}`
    end

    def rm
      `docker rm #{name}`
    end

    def to_s
      "#{self.class.name.downcase} #{name}"
    end
  end

  def container
    @container ||= Container.new(image.name)
  end

  def image
    @image ||= Image.new(app_name)
  end

  def app_name
    Pathname(Rake.application.original_dir).basename.to_s
  end

  desc 'Stop the container'
  task :stop do
    container.stop if container.running?
    puts "#{container} stopped"
  end

  desc 'Remove the container'
  task rm: [:stop] do
    if !container.exist?
      puts "No need to remove #{container}; it doesn't exist."
    else
      puts "Removing #{container}"
      container.rm
      puts "#{container} was removed"
    end
  end

  desc 'Build the image'
  task :build do |t|
    puts "Rebuilding #{image}"
    sh "docker build -t #{image.name} ."
    puts "Rebuilt #{image}"
  end

  desc 'Run the image as new container'
  task run: [:build] do
    puts "Running #{image}..."
    image.run(name: container.name, detach: true, publish: { 49857 => 9292 })
    puts "#{image} is now running as #{container}"
  end

  desc 'Re-build and run the container'
  task restart: [:build, :rm, :run]

  desc "Promote the latest #{image.name} image from default to production"
  task :promote do
    size = `docker $(docker-machine config default) images --format \"{{.Size}}\" #{image.name}:latest`.chomp
    puts "Promoting image '#{image.name}:latest' (#{size}) from 'default' to 'production'"
    sh 'docker $(docker-machine config default) save #{image.name}:latest | pv | docker $(docker-machine config production) load'
  end
end
