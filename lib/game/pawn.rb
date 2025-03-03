require_relative '../game'

class Pawn
  attr_reader :color, :symbol, :starting_position

  def initialize color, starting_position
    @color = color
    @symbol = color == 'white' ? "\u2659 " : "\u265F "
    @starting_position = starting_position
    @current_position = nil
  end
end