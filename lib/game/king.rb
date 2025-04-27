require_relative '../game'
require 'pry-byebug'

class King
  attr_reader :color, :symbol, :starting_position_cell, :current_position, :board, :all_moves, :way_to_king, :king_moved, :kingside_castling, :queenside_castling

  def initialize color, starting_position_cell, board
    @board = board
    @color = color
    @symbol = color == 'white' ? "\u2654 " : "\u265A "
    @starting_position_cell = starting_position_cell
    @current_position = board.cell_names[starting_position_cell]
    @all_moves = nil
    @way_to_king = nil
    @king_moved = nil
    @kingside_castling = nil
    @queenside_castling = nil
  end

  def as_json
    {
      color: @color,
      starting_position_cell: @starting_position_cell,
      current_position: @current_position,
      all_moves: @all_moves,
      way_to_king: @way_to_king,
      king_moved: @king_moved,
      kingside_castling: @kingside_castling,
      queenside_castling: @queenside_castling
    }
  end

  def to_json(*_args)
    as_json.to_json
  end

  def self.from_json(data, board)
    king = allocate
    king.instance_variable_set(:@color, data['color'])
    king.instance_variable_set(:@symbol, data['color'] == "white" ? "\u2654 " : "\u265A ")
    king.instance_variable_set(:@starting_position_cell, data['starting_position_cell'])
    king.instance_variable_set(:@current_position, data['current_position'])
    king.instance_variable_set(:@all_moves, data['all_moves'])
    king.instance_variable_set(:@way_to_king, data['way_to_king'])
    king.instance_variable_set(:@king_moved, data['king_moved'])
    king.instance_variable_set(:@kingside_castling, data['kingside_castling'])
    king.instance_variable_set(:@queenside_castling, data['queenside_castling'])
    king.instance_variable_set(:@board, board)
    
    king
  end

  def available_moves
    check_castling

    directions = [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1],
      [-1, -1],
      [-1, 1],
      [1, 1],
      [1, -1]
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

        if occupant.nil? && (kingside_castling && queenside_castling)
          reachable << [r, c]
          color == 'white' ? reachable << [7, 2] << [7, 6] : reachable << [0, 2] << [0, 6]
          break
        elsif occupant.nil? && kingside_castling
          reachable << [r, c]
          color == 'white' ? reachable << [7, 6] : reachable << [0, 6]
          # reachable << color == 'white' ? [7, 6] : [0, 6]
          break
        elsif occupant.nil? && queenside_castling
          reachable << [r, c]
          color == 'white' ? reachable << [7, 2] : reachable << [0, 2]
          # reachable << color == 'white' ? [7, 2] : [0, 2]
          break
        elsif occupant.nil?
          reachable << [r, c]
          break
        else
          if occupant && occupant.color != color && (occupant.symbol == "\u2654 " || occupant.symbol == "\u265A ")
            reachable << [r, c]
            way << [r, c]
            way << current_position
            @way_to_king = way.dup
          elsif occupant && occupant.color != color
            reachable << [r, c]
          end
          break
        end
      end
      way.clear
    end

    @all_moves = reachable
    @kingside_castling = nil
    @queenside_castling = nil
  end

  def check_castling
    if (kingside_castling_possible? && queenside_castling_possible?)
      @kingside_castling = true
      @queenside_castling = true
    elsif kingside_castling_possible?
      @kingside_castling = true
    elsif queenside_castling_possible?
      @queenside_castling = true
    end
  end

  def kingside_castling_possible?
    if color == 'white'
      rook = "\u2656 "
      return false if board.chesspiece[:H1]&.symbol != rook
      rook_didnt_move = board.chesspiece[:H1].rook_moved == nil
    
      rook_didnt_move && (board.chesspiece[:F1] && board.chesspiece[:G1]).nil?
    else
      rook = "\u265C "
      return false if board.chesspiece[:H8]&.symbol != rook
      rook_didnt_move = board.chesspiece[:H8].rook_moved == nil

      rook_didnt_move && (board.chesspiece[:F8] && board.chesspiece[:G8]).nil?
    end
  end

  def queenside_castling_possible?
    if color == 'white'
      rook = "\u2656 "
      return false if board.chesspiece[:A1]&.symbol != rook
      rook_didnt_move = board.chesspiece[:A1].rook_moved == nil

      rook_didnt_move && (board.chesspiece[:D1] && board.chesspiece[:C1] && board.chesspiece[:B1]).nil?
    else
      rook = "\u265C "
      return false if board.chesspiece[:A8]&.symbol != rook
      rook_didnt_move = board.chesspiece[:A8].rook_moved == nil

      rook_didnt_move && (board.chesspiece[:D8] && board.chesspiece[:C8] && board.chesspiece[:B8]).nil?
    end
  end

  def moves(to)
    available_moves
    cell_name = board.cell_names.key(to)
    binding.pry

    if all_moves.any?(to)
      chesspiece_moves(to, cell_name)
      return true
    else
      puts 'You cannot make this move!'
      return false
    end
  end

  def chesspiece_moves(to, cell_name)
    castling_fields = [:G1, :G8, :C1, :C8]

    if castling_fields.include?(cell_name) && king_moved == nil
      move_king(to, cell_name)

      if cell_name == :G1 || cell_name == :G8
        move_rook(cell_name, 'kingside')
      else
        move_rook(cell_name, 'queenside')
      end
      @king_moved = true
      return
    end

    old_cell = board.cell_names.key(current_position)

    @board.board[current_position[0]][current_position[1]] = '  '
    @board.chesspiece.delete(old_cell)
    @starting_position_cell = cell_name
    @current_position = to
    @board.board[to[0]][to[1]] = symbol
    @board.chesspiece[cell_name] = self
    @king_moved = true
  end

  def move_king(to, cell_name)
    old_cell = board.cell_names.key(current_position)

    @board.board[current_position[0]][current_position[1]] = '  '
    @board.chesspiece.delete(old_cell)
    @starting_position_cell = cell_name
    @current_position = to

    king = King.new(color, cell_name, @board)
    @board.chesspiece[cell_name] = king
    @board.board[board.cell_names[cell_name][0]][board.cell_names[cell_name][1]] = king.symbol
  end

  def move_rook(cell_name, castling_side)
    white_kingside_rook = @board.chesspiece[:H1]
    white_queenside_rook = @board.chesspiece[:A1]
    black_kingside_rook = @board.chesspiece[:H8]
    black_queenside_rook = @board.chesspiece[:A8]

    if color == 'white'
      if castling_side == 'kingside'
        @board.board[7][7] = '  '
        @board.chesspiece.delete(:H1)
        white_kingside_rook.starting_position_cell = :F1
        white_kingside_rook.current_position = [7, 5]

        rook = Rook.new(color, :F1, @board)
        @board.chesspiece[:F1] = rook
        @board.board[board.cell_names[white_kingside_rook.starting_position_cell][0]][board.cell_names[white_kingside_rook.starting_position_cell][1]] = rook.symbol
      else
        @board.board[7][0] = '  '
        @board.chesspiece.delete(:A1)
        white_queenside_rook.starting_position_cell = :D1
        white_queenside_rook.current_position = [7, 3]

        rook = Rook.new(color, :D1, @board)
        @board.chesspiece[:D1] = rook
        @board.board[board.cell_names[white_queenside_rook.starting_position_cell][0]][board.cell_names[white_queenside_rook.starting_position_cell][1]] = rook.symbol
      end
    else
      if castling_side == 'kingside'
        @board.board[0][7] = '  '
        @board.chesspiece.delete(:H8)
        black_kingside_rook.starting_position_cell = :F8
        black_kingside_rook.current_position = [0, 5]

        rook = Rook.new(color, :F8, @board)
        @board.chesspiece[:F8] = rook
        @board.board[board.cell_names[black_kingside_rook.starting_position_cell][0]][board.cell_names[black_kingside_rook.starting_position_cell][1]] = rook.symbol
      else
        @board.board[0][0] = '  '
        @board.chesspiece.delete(:A8)
        black_queenside_rook.starting_position_cell = :D8
        black_queenside_rook.current_position = [0, 3]
        
        rook = Rook.new(color, :D8, @board)
        @board.chesspiece[:D8] = rook
        @board.board[board.cell_names[black_queenside_rook.starting_position_cell][0]][board.cell_names[black_queenside_rook.starting_position_cell][1]] = rook.symbol
      end
    end
  end
end