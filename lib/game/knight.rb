require_relative '../game'

class Knight
  attr_reader :color, :symbol, :starting_position

  def initialize color, symbol, starting_position
    @color = color
    @symbol = symbol
    @starting_position = starting_position
    @current_position = nil
  end
end
