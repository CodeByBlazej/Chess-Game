require_relative '../game'
require 'pry-byebug'

class Rook
  attr_reader :color, :symbol, :starting_position_cell, :current_position, :board, :all_moves

  def initialize color, starting_position_cell, board
    @board = board
    @color = color
    @symbol = color == 'white' ? "\u2656 " : "\u265C "
    @starting_position_cell = starting_position_cell
    @current_position = board.cell_names[starting_position_cell]
    @all_moves = nil
  end

  def available_moves
    moves = [-7, 0, 7].shuffle
    allowed_moves = moves.permutation(2).reject { |a, b| (a + b).zero? }
    potential_moves = allowed_moves.map { |a, b| [a + current_position[0], b + current_position[1]] }
    @all_moves = potential_moves.select do |a, b|
      a >= 0 && a <= 7 && b >= 0 && b <= 7
    end
  end

  def on_the_way
    start = current_position
    p start
  end
end
