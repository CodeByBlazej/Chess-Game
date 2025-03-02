require_relative '../game'

class Rook
  attr_reader :color, :symbol, :starting_position

  def initialize color, starting_position
    @color = color
    @symbol = color == 'white' ? "\u2656 " : "\u265C "
    @starting_position = starting_position
    @current_position = nil
  end
end