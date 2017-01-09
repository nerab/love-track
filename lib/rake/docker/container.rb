# frozen_string_literal: true
module Docker
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
      "#{self.class.name.split('::').last.downcase} '#{name}'"
    end
  end
end
