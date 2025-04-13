require_relative '../game'

class Board
  attr_reader :board, :white, :black, :knight, :cell_names, :chesspiece, :black_chesspieces_moves, :white_chesspieces_moves, :black_king_moves, :white_king_moves, :black_king_position, :white_king_position

  def initialize 
    @board = Array.new(8) { Array.new(8, '  ') }
    @white = "\e[0;100m"
    @black = "\e[40m"
    # @knight = Knight.new('white', "\u2658 ")
    @cell_names = {}
    @chesspiece = {}
    @black_chesspieces_moves = nil
    @white_chesspieces_moves = nil
    @black_king_moves = nil
    @white_king_moves = nil
    @black_king_position = nil
    @white_king_position = nil
  end

  def as_json
    {
      board: @board,
      white: @white,
      black: @black,
      cell_names: @cell_names,
      chesspiece: @chesspiece,
      black_chesspieces_moves: @black_chesspieces_moves,
      white_chesspieces_moves: @white_chesspieces_moves,
      black_king_moves: @black_king_moves,
      white_king_moves: @white_king_moves,
      black_king_position: @black_king_position,
      white_king_position: @white_king_position
    }
  end

  def to_json(*_args)
    as_json.to_json
  end

  def self.from_json(data)
    instance = new
    instance.instance_variable_set(:@board, data['board'])
    instance.instance_variable_set(:@white, data['white'])
    instance.instance_variable_set(:@black, data['black'])
    instance.instance_variable_set(:@cell_names, data['cell_names'])
    instance.instance_variable_set(:@chesspiece, data['chesspiece'])
    instance.instance_variable_set(:@black_chesspieces_moves, data['black_chesspieces_moves'])
    instance.instance_variable_set(:@white_chesspieces_moves, data['white_chesspieces_moves'])
    instance.instance_variable_set(:@black_king_moves, data['black_king_moves'])
    instance.instance_variable_set(:@white_king_moves, data['white_king_moves'])
    instance.instance_variable_set(:@black_king_position, data['black_king_position'])
    instance.instance_variable_set(:@white_king_position, data['white_king_position'])
    instance
  end

  def display_board
    name_cells

    board.each_with_index do |row, row_idx|
      print "#{8 - row_idx}"
      
      row.each_with_index do |cell, col_idx|
        background = (row_idx + col_idx).even? ? white : black
        print "#{background}#{cell}\e[0m"
      end

      puts
    end
    puts " A B C D E F G H "
  end

  def name_cells
    alphabet = ('A'..'H').to_a

    board.each_with_index do |row, row_idx|
      row.each_with_index do |cell, col_idx|
        cell_names[:"#{alphabet[col_idx]}#{8 - row_idx}"] = [row_idx, col_idx]
      end
    end
    # puts cell_names
  end

  def create_black_chesspieces_moves
    moves = []
    black_chesspieces = chesspiece.values.select { |chesspiece| chesspiece && chesspiece.color == 'black' }
    black_chesspieces.each { |chesspiece| moves << chesspiece.all_moves }
    
    @black_chesspieces_moves = moves.flatten(1)

    # puts "black_opponent_moves = #{black_opponent_moves.flatten(1)}"

    #finish doing this method and start copying more from game.rb
    #create class variables and set black_opponent_moves to flatten(1)
    #call everything nicely in chessmate in game and check if it works
    #the same like from moves branch
  end

  def create_white_chesspieces_moves
    moves = []
    white_chesspieces = chesspiece.values.select { |chesspiece| chesspiece && chesspiece.color == 'white' }
    white_chesspieces.each { |chesspiece| moves << chesspiece.all_moves }

    @white_chesspieces_moves = moves.flatten(1)
    
    # puts "white_opponent_moves = #{white_opponent_moves.flatten(1)}" 
  end

  def create_black_king_moves
    moves = []
    black_king = chesspiece.values.select { |chesspiece| chesspiece && chesspiece.symbol == "\u265A " }
    black_king.each { |chesspiece| moves << chesspiece.all_moves }
    
    position = []
    black_king.each { |chesspiece| position << chesspiece.current_position }

    @black_king_moves = moves.flatten(1)
    @black_king_position = position.flatten(1)

    # puts "black_king_moves = #{black_king_moves.flatten(1)}"
  end

  def create_white_king_moves
    #update this with find rather than select
    moves = []
    white_king = chesspiece.values.select { |chesspiece| chesspiece && chesspiece.symbol == "\u2654 " }
    white_king.each { |chesspiece| moves << chesspiece.all_moves }

    position = []
    white_king.each { |chesspiece| position << chesspiece.current_position }

    @white_king_moves = moves.flatten(1)
    @white_king_position = position.flatten(1)

    # puts "white_king_moves = #{white_king_moves.flatten(1)}"
  end

end