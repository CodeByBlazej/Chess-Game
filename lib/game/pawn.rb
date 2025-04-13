require_relative '../game'
require 'pry-byebug'

class Pawn
  attr_reader :color, :symbol, :starting_position_cell, :current_position, :board, :all_moves, :way_to_king

  def initialize color, starting_position_cell, board
    @board = board
    @color = color
    @symbol = color == 'white' ? "\u2659 " : "\u265F "
    @starting_position_cell = starting_position_cell
    @current_position = board.cell_names[starting_position_cell]
    @all_moves = nil
    @way_to_king = nil
  end

  def as_json
    {
      board: @board,
      color: @color,
      symbol: @symbol,
      starting_position_cell: @starting_position_cell,
      current_position: @current_position,
      all_moves: @all_moves,
      way_to_king: @way_to_king
    }
  end

  def to_json(*_args)
    as_json.to_json
  end

  def self.from_json(data)
    instance = new
    instance.instance_variable_set(:@board, data['board'])
    instance.instance_variable_set(:@color, data['color'])
    instance.instance_variable_set(:@symbol, data['symbol'])
    instance.instance_variable_set(:@starting_position_cell, data['starting_position_cell'])
    instance.instance_variable_set(:@current_position, data['current_position'])
    instance.instance_variable_set(:@all_moves, data['all_moves'])
    instance.instance_variable_set(:@way_to_king, data['way_to_king'])
    instance
  end

  def available_moves
    directions = color == 'white' ? [[-1, 0], [-1, -1], [-1, 1]] : [[1, 0], [1, 1], [1, -1]]

    row, col = current_position
    reachable = []
    way = []
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
        elsif occupant && occupant.color != color && (occupant.symbol == "\u2654 " || occupant.symbol == "\u265A ") && iteration > 1
          reachable << [r, c]
          way << [r, c]
          way << current_position
          @way_to_king = way.dup
          break
        elsif occupant && occupant.color != color && iteration > 1
          reachable << [r, c]
          break
        else
          break
        end
      end
      way.clear
    end

    @all_moves = reachable
  end

  def first_move?
    if color == 'white'
      current_position[0] == 6
    else
      current_position[0] == 1
    end
  end

  def last_move?(to)
    if color == 'white'
      to[0] == 0
    else
      to[0] == 7
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
    if last_move?(to)
      @board.board[current_position[0]][current_position[1]] = '  '
      @board.chesspiece[starting_position_cell] = nil
      @starting_position_cell = cell_name
      @current_position = to

      queen = Queen.new(color, cell_name, @board)
      @board.chesspiece[cell_name] = queen
      @board.board[board.cell_names[cell_name][0]][board.cell_names[cell_name][1]] = queen.symbol
      return
    end

    @board.board[current_position[0]][current_position[1]] = '  '
    @board.chesspiece[starting_position_cell] = nil
    @starting_position_cell = cell_name
    @current_position = to
    @board.board[to[0]][to[1]] = symbol
    @board.chesspiece[cell_name] = self
  end
end