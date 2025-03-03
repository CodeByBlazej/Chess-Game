require_relative '../game'

class Queen
  attr_reader :color, :symbol, :starting_position

  def initialize color, starting_position
    @color = color
    @symbol = color == 'white' ? "\u2655 " : "\u265B "
    @starting_position = starting_position
    @current_position = nil
  end
end