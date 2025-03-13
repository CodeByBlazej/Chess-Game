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

    # if first_move?
    #   directions.unshift(color == 'white' ? [-1, 0] : [1, 0])
    # end

    row, col = current_position
    reachable = []
    iteration = 0

    directions.each do |dr, dc|
      r, c = row, col
      # iteration += 1

      loop do
        r += dr
        c += dc
        iteration += 1

        break unless r.between?(0, 7) && c.between?(0, 7)

        cell_name = board.cell_names.key([r, c])
        occupant = board.chesspiece[cell_name]

        if occupant.nil? && iteration <= 2
          reachable << [r, c]
          if first_move?
            color == 'white' ? directions.insert(1, [-1, 0]) : directions.insert(1, [2, 0])
            # reachable << [r, c]
            # iteration + 1
          else
            break
          end
          # break
        end
      end
    end

    @all_moves = reachable
    puts "DEBUG: Available moves for #{symbol} at #{current_position}: #{@all_moves.inspect}"
  end

  def first_move?
    if color == 'white'
      # game.white_chesspieces_positions[:pawn].any?(self.starting_position_cell)
      current_position[0] == 6
    else
      # game.black_chesspieces_positions[:pawn].any?(self.starting_position_cell)
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