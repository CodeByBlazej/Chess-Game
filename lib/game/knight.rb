require_relative '../game'

class Knight
  attr_reader :color, :symbol

  def initialize color, symbol
    @color = color
    @symbol = symbol
    @starting_position = nil
    @current_position = nil
  end
end
