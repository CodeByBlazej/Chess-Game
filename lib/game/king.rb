require_relative '../game'

class King
  attr_reader :color, :symbol, :starting_position

  def initialize color, starting_position
    @color = color
    @symbol = color == 'white' ? "\u2654 " : "\u265A "
    @starting_position = starting_position
    @current_position = nil
  end
end