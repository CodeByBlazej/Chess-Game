require_relative '../game'
require 'pry-byebug'

class Knight
  attr_reader :color, :symbol, :starting_position_cell, :current_position, :board, :all_moves

  def initialize color, starting_position_cell, board
    @board = board
    @color = color
    @symbol = color == 'white' ? "\u2658 " : "\u265E "
    @starting_position_cell = starting_position_cell
    @starting_position_coord = nil
    @current_position = board.cell_names[starting_position_cell]
    @all_moves = nil
  end

  def available_moves
    moves = [-2, -1, 1, 2].shuffle
    allowed_moves = moves.permutation(2).reject { |a, b| (a + b).zero? }
    potential_moves = allowed_moves.map { |a, b| [a + current_position[0], b + current_position[1]] }
    @all_moves = potential_moves.select do |a, b|
      a >= 0 && a <= 7 && b >= 0 && b <= 7
    end
  end

  def moves(to)
    available_moves

    cell_name = board.cell_names.key(to)

    if all_moves.any?(to) && board.chesspiece[cell_name] == nil
      # chesspiece moves to that place!
      @board.board[current_position[0]][current_position[1]] = '  '
      @board.chesspiece[starting_position_cell] = nil
      @current_position = to
      @board.board[to[0]][to[1]] = symbol
      @board.chesspiece[cell_name] = self
      return
    elsif all_moves.any?(to) && board.chesspiece[cell_name].color == color
      puts "This cell is occupied by other chesspiece of yours! Please select other cell..."
    elsif all_moves.any?(to) && board.chesspiece[cell_name].color == 'black'
      # kill method here!
      @board.board[current_position[0]][current_position[1]] = '  '
      @board.chesspiece[starting_position_cell] = nil
      @current_position = to
      @board.board[to[0]][to[1]] = symbol
      @board.chesspiece[cell_name] = self
    else
      puts 'You cannot make this move!'
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
    # p moves
    # binding.pry
    p 'finish'
    # think about changing how game creates each object. instead of 
    # passing starting position pass only board and then in each object
    # make starting position out of board.cell_names where needed
  end
end
