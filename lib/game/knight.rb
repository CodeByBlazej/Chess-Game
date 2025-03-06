require_relative '../game'
require 'pry-byebug'

class Knight
  attr_reader :color, :symbol, :starting_position, :current_position, :board

  def initialize color, starting_position_cell, board
    @board = board
    @color = color
    @symbol = color == 'white' ? "\u2658 " : "\u265E "
    @starting_position_cell = starting_position_cell
    @starting_position_coord = nil
    @current_position = board.cell_names[starting_position_cell]
    # @starting_position2 = board.cell_names[starting_position]
  end

  def available_moves
    moves = [-2, -1, 1, 2].shuffle
    allowed_moves = moves.permutation(2).reject { |a, b| (a + b).zero? }
    potential_moves = allowed_moves.map { |a, b| [a + current_position[0], b + current_position[1]] }
    board_moves = potential_moves.select do |a, b|
      a >= 0 && a <= 7 && b >= 0 && b <= 7
    end
    board_moves.select do |coordinates|
      cell_name = board.cell_names.key(coordinates)
      board.chesspiece[cell_name] == nil
    end
  end

  def test_display
    puts @starting_position_cell
    p @starting_position_cell
    puts @current_position
    p @current_position
    p @board.cell_names[:B1]
    p @starting_position2
    p available_moves
    # binding.pry
    p 'finish'
    # think about changing how game creates each object. instead of 
    # passing starting position pass only board and then in each object
    # make starting position out of board.cell_names where needed
  end
end
