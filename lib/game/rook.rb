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
    directions = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1],
    ]

    row, col = current_position
    reachable = []

    directions.each do |dr, dc|
      r, c = row, col

      loop do
        r += dr
        c += dc

        break unless r.between?(0, 7) && c.between?(0, 7)

        cell_name = board.cell_names.key([r, c])
        occupant = board.chesspiece[cell_name]

        if occupant.nil?
          reachable << [r, c]
        else 
          if occupant.color != color
            reachable << [r, c]
          end
          break
        end
      end
    end

    @all_moves = reachable
  end

  def moves(to)
    available_moves
    cell_name = board.cell_names.key(to)
    occupant = board.chesspiece[cell_name]

    if all_moves.any?(to)
      chesspiece_moves(to, cell_name)
      return
    elsif occupant && occupant.color == color && same_row_and_col
      puts "This cell is occupied by other chesspiece of yours! Please select other cell..."
    else
      puts 'You cannot make this move!'
    end
  end

  def chesspiece_moves(to, cell_name)
    @board.board[current_position[0]][current_position[1]] = '  '
    @board.chesspiece[starting_position_cell] = nil
    @current_position = to
    @board.board[to[0]][to[1]] = symbol
    @board.chesspiece[cell_name] = self
  end

end
