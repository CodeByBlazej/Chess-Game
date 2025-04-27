require_relative '../game'
require 'pry-byebug'

class Bishop
  attr_reader :color, :symbol, :starting_position_cell, :current_position, :board, :all_moves, :way_to_king

  def initialize color, starting_position_cell, board
    @board = board
    @color = color
    @symbol = color == 'white' ? "\u2657 " : "\u265D "
    @starting_position_cell = starting_position_cell
    @current_position = board.cell_names[starting_position_cell]
    @all_moves = nil
    @way_to_king = nil
  end

  def as_json
    {
      color: @color,
      starting_position_cell: @starting_position_cell,
      current_position: @current_position,
      all_moves: @all_moves,
      way_to_king: @way_to_king
    }
  end

  def to_json(*_args)
    as_json.to_json
  end

  def self.from_json(data, board)
    bishop = allocate
    bishop.instance_variable_set(:@color, data['color'])
    bishop.instance_variable_set(:@symbol, data['color'] == "white" ? "\u2657 " : "\u265D ")
    bishop.instance_variable_set(:@starting_position_cell, data['starting_position_cell'])
    bishop.instance_variable_set(:@current_position, data['current_position'])
    bishop.instance_variable_set(:@all_moves, data['all_moves'])
    bishop.instance_variable_set(:@way_to_king, data['way_to_king'])
    bishop.instance_variable_set(:@board, board)
    
    bishop
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
    way = []

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
          way << [r, c]
        else
          if occupant.color != color && (occupant.symbol == "\u2654 " || occupant.symbol == "\u265A ")
            reachable << [r, c]
            way << [r, c]
            way << current_position
            @way_to_king = way.dup
          elsif occupant.color != color && occupant.symbol != "\u2654 " && occupant.symbol != "\u265A "
            reachable << [r, c]
          end
          break
        end
      end
      way.clear
    end

    @all_moves = reachable
  end

  def moves(to)
    available_moves
    cell_name = board.cell_names.key(to)

    if all_moves.any?(to)
      chesspiece_moves(to, cell_name)
      return true
    else
      puts 'You cannot make this move!'
      return false
    end
  end

  def chesspiece_moves(to, cell_name)
    old_cell = board.cell_names.key(current_position)

    @board.board[current_position[0]][current_position[1]] = '  '
    @board.chesspiece.delete(old_cell)
    @starting_position_cell = cell_name
    @current_position = to
    @board.board[to[0]][to[1]] = symbol
    @board.chesspiece[cell_name] = self
  end
end