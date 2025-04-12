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

  def self.from_json(data)
    new(data['name'], data['color'])
  end
end 