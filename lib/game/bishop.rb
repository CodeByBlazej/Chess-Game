require_relative '../game'

class Bishop
  attr_reader :color, :symbol, :starting_position

  def initialize color, starting_position
    @color = color
    @symbol = color == 'white' ? "\u2657 " : "\u265D "
    @starting_position = starting_position
    @current_position = nil
  end
end