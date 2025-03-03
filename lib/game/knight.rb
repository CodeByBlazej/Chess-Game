require_relative '../game'

class Knight
  attr_reader :color, :symbol, :starting_position

  def initialize color, starting_position
    @color = color
    @symbol = color == 'white' ? "\u2658 " : "\u265E "
    @starting_position = starting_position
    @current_position = nil
  end
end
