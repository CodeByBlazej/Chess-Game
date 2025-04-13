require_relative '../game'

class Players
  attr_reader :name, :color

  def initialize name, color
    @name = name
    @color = color
  end

  def as_json
    {
      name: @name,
      color: @color
    }
  end

  def to_json(*_args)
    as_json.to_json
  end

  def self.from_json(data)
    instance = new
    instance.instance_variable_set(:@name, data['name'])
    instance.instance_variable_set(:@color, data['color'])
    instance
  end
end 