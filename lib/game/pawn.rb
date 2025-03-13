require_relative '../game'
require 'pry-byebug'

class Pawn
  attr_reader :color, :symbol, :starting_position_cell, :current_position, :board, :all_moves

  def initialize color, starting_position_cell, board
    @board = board
    @color = color
    @symbol = color == 'white' ? "\u2659 " : "\u265F "
    @starting_position_cell = starting_position_cell
    @current_position = board.cell_names[starting_position_cell]
    @all_moves = nil
  end

  def available_moves
    directions = color == 'white' ? [[-1, 0], [-1, -1], [-1, 1]] : [[1, 0], [1, 1], [1, -1]]

    row, col = current_position
    reachable = []
    iteration = 0
    moved = false

    directions.each do |dr, dc|
      r, c = row, col
      iteration += 1

      loop do
        r += dr
        c += dc

        break unless r.between?(0, 7) && c.between?(0, 7)

        cell_name = board.cell_names.key([r, c])
        occupant = board.chesspiece[cell_name]

        if occupant.nil? && iteration == 1 && first_move? && moved == false
          reachable << [r, c]
          moved = true
        elsif occupant.nil? && iteration == 1 && first_move? && moved == true
          reachable << [r, c]
          break
        elsif occupant.nil? && iteration == 1 
          reachable << [r, c]
          break
        elsif occupant && occupant.color != color
          reachable << [r, c]
          break
        else
          break
        end
      end
    end

    @all_moves = reachable
    puts "DEBUG: Available moves for #{symbol} at #{current_position}: #{@all_moves.inspect}"
  end

  def first_move?
    if color == 'white'
      current_position[0] == 6
    else
      current_position[0] == 1
    end
  end

  def moves(to)
    available_moves
    cell_name = board.cell_names.key(to)

    if all_moves.any?(to)
      chesspiece_moves(to, cell_name)
      return
    else
      puts 'You cannot make this move!'
    end
  end

  def chesspiece_moves(to, cell_name)
    @board.board[current_position[0]][current_position[1]] = '  '
    @board.chesspiece[starting_position_cell] = nil
    @starting_position_cell = cell_name
    @current_position = to
    @board.board[to[0]][to[1]] = symbol
    @board.chesspiece[cell_name] = self

    puts "DEBUG: #{symbol} moved to #{to}, new position: #{@current_position.inspect}"
  end
end