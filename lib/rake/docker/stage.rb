# frozen_string_literal: true
module Docker
  Stage = Struct.new(:name) do
    def to_s
      "#{self.class.name.split('::').last.downcase} '#{name}'"
    end
  end
end
