require_relative '../game'
require 'pry-byebug'

class Bishop
  attr_reader :color, :symbol, :starting_position_cell, :current_position, :board, :all_moves

  def initialize color, starting_position_cell, board
    @board = board
    @color = color
    @symbol = color == 'white' ? "\u2657 " : "\u265D "
    @starting_position_cell = starting_position_cell
    @current_position = board.cell_names[starting_position_cell]
    @all_moves = nil
  end

  def available_moves
    directions = [
      [-1, 1],
      [1, 1],
      [1, -1],
      [-1, -1]
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
end