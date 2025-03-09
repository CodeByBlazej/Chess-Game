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
      
      loop do
        row += dr
        col += dc

        break unless row.between?(0, 7) && col.between?(0, 7)

        cell_name = board.cell_names.key([row, col])
        occupant = board.chesspiece[cell_name]

        if occupant.nil?
          reachable << [row, col]
        else
          if occupant.color != color
            reachable << [row, col]
          end
          break
        end
      end
    end

    reachable
  end

end
