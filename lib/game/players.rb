require_relative '../game'

class Players
  attr_reader :name

  def initialize name
    @name = name
  end
end 