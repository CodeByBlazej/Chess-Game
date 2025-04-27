require_relative 'game/players'
require_relative 'game/board'
require_relative 'game/knight'
require_relative 'game/rook'
require_relative 'game/bishop'
require_relative 'game/queen'
require_relative 'game/king'
require_relative 'game/pawn'
require 'json'
require 'pry-byebug'

class Game
  attr_reader :board, :player1_name, :player2_name, :player1, :player2, :white_chesspieces_positions, :black_chesspieces_positions, :chesspiece_to_move, :cell_to_go, :next_turn_player, :check, :defending_chesspieces_cells, :opponent_way_to_king_cells, :king_escape_moves, :king_selected, :opponent_chesspiece_moves

  def initialize
    @board = Board.new
    @white_chesspieces_positions = {}
    @black_chesspieces_positions = {}
    @chesspiece_to_move = nil
    @cell_to_go = nil
    @next_turn_player = nil
    @check = nil
    @defending_chesspieces_cells = nil
    @opponent_way_to_king_cells = nil
    @king_escape_moves = nil
    @king_selected = nil
    @opponent_chesspiece_moves = nil
  end

  def as_json
    {
      board: @board.as_json,
      player1: @player1.as_json,
      player2: @player2.as_json,
      white_chesspieces_positions: @white_chesspieces_positions,
      black_chesspieces_positions: @black_chesspieces_positions,
      chesspiece_to_move: @chesspiece_to_move,
      cell_to_go: @cell_to_go,
      next_turn_player: @next_turn_player&.color,
      check: @check,
      defending_chesspieces_cells: @defending_chesspieces_cells,
      opponent_way_to_king_cells: @opponent_way_to_king_cells,
      king_escape_moves: @king_escape_moves,
      king_selected: @king_selected,
      opponent_chesspiece_moves: @opponent_chesspiece_moves,
    }
  end

  def to_json(*_args)
    as_json.to_json
  end

  def self.from_json(data)
    instance = new
    instance.instance_variable_set(:@board, Board.from_json(data['board']))
    instance.instance_variable_set(:@player1, Players.from_json(data['player1']))
    instance.instance_variable_set(:@player2, Players.from_json(data['player2']))

    next_turn_player_color = data['next_turn_player']

    instance.instance_variable_set(:@next_turn_player,
    [instance.player1, instance.player2].find { |player| player.color == next_turn_player_color })

    instance.instance_variable_set(:@white_chesspieces_positions, data['white_chesspieces_positions'])
    instance.instance_variable_set(:@black_chesspieces_positions, data['black_chesspieces_positions'])
    instance.instance_variable_set(:@chesspiece_to_move, data['chesspiece_to_move'])
    instance.instance_variable_set(:@cell_to_go, data['cell_to_go'])
    instance.instance_variable_set(:@check, data['check'])
    instance.instance_variable_set(:@defending_chesspieces_cells, data['defending_chesspieces_cells'])
    instance.instance_variable_set(:@opponent_way_to_king_cells, data['opponent_way_to_king_cells'])
    instance.instance_variable_set(:@king_escape_moves, data['king_escape_moves'])
    instance.instance_variable_set(:@king_selected, data['king_selected'])
    instance.instance_variable_set(:@opponent_chesspiece_moves, data['opponent_chesspiece_moves'])

    instance
  end


  def save_game(filename)
    File.open(filename, 'w') { |f| f.write(to_json) }
  end

  def self.load_game(filename)
    data = JSON.parse(File.read(filename))
    from_json(data)
  end

  def play_game
    if board.chesspiece.empty?
      puts 'Please select players names!'
      create_players
      board.display_board
      create_chesspieces_and_add_to_board('white')
      create_chesspieces_and_add_to_board('black')
      board.display_board
    else
      puts 'Game loaded successfully! Resuming your game...'
    end

    board.display_board
    play_round until end_game
  end

  def create_players
    puts 'Player 1, what is your name?'
    @player1_name = gets.chomp
    puts 'Player 2, what is your name?'
    @player2_name = gets.chomp

    name = [player1_name, player2_name].sample

    name_of_player1 = name
    name_of_player2 = name == player1_name ? player2_name : player1_name
    puts "Player - #{name_of_player1} got assigned WHITE color"
    @player1 = Players.new(name_of_player1, 'white')
    puts "Player - #{name_of_player2} got assigned BLACK color"
    @player2 = Players.new(name_of_player2, 'black')
  end

  def create_chesspieces_and_add_to_board(color)
    create_chesspieces_positions(color)

    color == 'white' ? col_pos = white_chesspieces_positions : col_pos = black_chesspieces_positions

    col_pos.each_pair do |key, values|
      case key
      when :rook
        values.each do |value|
          rook = Rook.new(color, value, @board)
          board.chesspiece[value] = rook
          board.board[board.cell_names[value][0]][board.cell_names[value][1]] = rook.symbol 
        end
      when :knight
        values.each do |value|
          knight = Knight.new(color, value, @board)
          board.chesspiece[value] = knight
          board.board[board.cell_names[value][0]][board.cell_names[value][1]] = knight.symbol
        end
      when :bishop
        values.each do |value|
          bishop = Bishop.new(color, value, @board)
          board.chesspiece[value] = bishop
          board.board[board.cell_names[value][0]][board.cell_names[value][1]] = bishop.symbol
        end
      when :queen
        values.each do |value|
          queen = Queen.new(color, value, @board)
          board.chesspiece[value] = queen
          board.board[board.cell_names[value][0]][board.cell_names[value][1]] = queen.symbol
        end
      when :king
        values.each do |value|
          king = King.new(color, value, @board)
          board.chesspiece[value] = king
          board.board[board.cell_names[value][0]][board.cell_names[value][1]] = king.symbol
        end
      when :pawn
        values.each do |value|
          pawn = Pawn.new(color, value, @board)
          board.chesspiece[value] = pawn
          board.board[board.cell_names[value][0]][board.cell_names[value][1]] = pawn.symbol
        end
      end
    end 
  end

  def create_chesspieces_positions(color)
    if color == 'white'
      @white_chesspieces_positions[:rook] = [:A1, :H1]
      @white_chesspieces_positions[:knight] = [:B1, :G1]
      @white_chesspieces_positions[:bishop] = [:C1, :F1]
      @white_chesspieces_positions[:queen] = [:D1]
      @white_chesspieces_positions[:king] = [:E1]
      @white_chesspieces_positions[:pawn] = [:A2, :B2, :C2, :D2, :E2, :F2, :G2, :H2]
    else
      @black_chesspieces_positions[:rook] = [:A8, :H8]
      @black_chesspieces_positions[:knight] = [:B8, :G8]
      @black_chesspieces_positions[:bishop] = [:C8, :F8]
      @black_chesspieces_positions[:queen] = [:D8]
      @black_chesspieces_positions[:king] = [:E8]
      @black_chesspieces_positions[:pawn] = [:A7, :B7, :C7, :D7, :E7, :F7, :G7, :H7]
    end
  end

  def play_round
    if next_turn_player == nil || next_turn_player == player1
      pick_chesspiece(player1)
      @next_turn_player = player2
    else
      pick_chesspiece(player2)
      @next_turn_player = player1
    end
  end

  def pick_chesspiece(player)
    puts "#{player.name} select chesspiece you want to move - for example A1 or E2"
    selected_chesspiece = gets.chomp.to_sym
    upcased_save = selected_chesspiece.to_s.upcase

    if upcased_save == 'SAVE'
      save_game('savegame.json')
      puts "Game has been saved!"
      pick_chesspiece(player)
    end

    until can_chesspiece_move?(selected_chesspiece) && board.chesspiece[selected_chesspiece].color == player.color do  
      if board.chesspiece[selected_chesspiece].nil?
        puts "You made a typo! Please try again..."
        selected_chesspiece = gets.chomp.to_sym
      elsif can_chesspiece_move?(selected_chesspiece) == false && @check
        puts "You have check! Pick such a chesspiece that will rescue your king!"
        selected_chesspiece = gets.chomp.to_sym
      elsif can_chesspiece_move?(selected_chesspiece) == false && board.chesspiece[selected_chesspiece].color != player.color
        puts "You cannot move your opponent chesspieces! Select one of yours..."
        selected_chesspiece = gets.chomp.to_sym
      elsif can_chesspiece_move?(selected_chesspiece) == false
        puts "This chesspiece has no moves available at this moment, select another one..."
        selected_chesspiece = gets.chomp.to_sym
      elsif board.chesspiece[selected_chesspiece].color != player.color
        puts "You cannot move your opponent chesspieces! Select one of yours..."
        selected_chesspiece = gets.chomp.to_sym
      end
    end

    @chesspiece_to_move = selected_chesspiece
    pick_cell(player)
  end

  def can_chesspiece_move?(selected_chesspiece)
    return false if board.chesspiece[selected_chesspiece].nil?

    if @check 
      if ["\u2654 ", "\u265A "].include?(board.chesspiece[selected_chesspiece].symbol) && @king_escape_moves.any?
        @king_selected = true
        return true
      elsif @defending_chesspieces_cells.any?(selected_chesspiece)
        return true
      else
        return false
      end
    end

    board.chesspiece[selected_chesspiece].available_moves
    available_moves = board.chesspiece[selected_chesspiece].all_moves
    available_moves.any?
  end

  def pick_cell(player)
    puts "#{player.name} select field you want to go - for example B3 or F4"
    selected_cell = gets.chomp.to_sym

    if @check
      until @opponent_way_to_king_cells.any?(selected_cell) || @king_selected do
        puts "You have to pick the field that would block your king! Please select another one..."
        selected_cell = gets.chomp.to_sym
      end

      if @king_selected
        until king_escape_moves.any?(selected_cell) do
          puts "You can't move there to escape from check! Select safe field!"
          selected_cell = gets.chomp.to_sym
        end
      end

    else
      until board.cell_names.keys.any?(selected_cell) do
        puts "You made a typo! Please try again..."
        selected_cell = gets.chomp.to_sym
      end
    end

    @cell_to_go = board.cell_names[selected_cell]
    make_move(player)
  end

  def make_move(player)
    success = board.chesspiece[chesspiece_to_move].moves(cell_to_go)

    unless success
      pick_chesspiece(player)
      return
    end
    
    @check = nil
    @king_selected = nil

    board.display_board
  end

  def end_game
    chessmate?
  end

  def chessmate?
    board.chesspiece.values.each { |chesspiece| chesspiece && chesspiece.available_moves }

    board.create_black_chesspieces_moves
    board.create_white_chesspieces_moves
    board.create_black_king_moves
    board.create_white_king_moves


    # puts "black_chesspieces_moves = #{board.black_chesspieces_moves}"
    # puts "white_chesspieces_moves = #{board.white_chesspieces_moves}" 
    # puts "black_king_moves = #{board.black_king_moves}"
    # puts "white_king_moves = #{board.white_king_moves}"
    # puts "black_king_position = #{board.black_king_position}"
    # puts "white_king_position = #{board.white_king_position}"

    breaks_chessmate?

    if next_turn_player == player1
      if board.white_king_moves.any? 
        check = opponent_chesspiece_moves.include?(board.white_king_position) && ( defending_chesspieces_cells.any? || king_escape_moves.any? )
        checkmate = (board.white_king_moves - board.black_chesspieces_moves).empty? && defending_chesspieces_cells.empty? && king_escape_moves.empty?
  
        if checkmate
          puts "Chessmate! #{player2.name} won the game!"
          return true
        elsif check
          puts "check!"
          @check = true
          false
        end
      end
    elsif next_turn_player == player2
      if board.black_king_moves.any?
        check = opponent_chesspiece_moves.include?(board.black_king_position) && ( defending_chesspieces_cells.any? || king_escape_moves.any? )
        checkmate = (board.black_king_moves - board.white_chesspieces_moves).empty? && defending_chesspieces_cells.empty? && king_escape_moves.empty?
  
        if checkmate
          puts "Chessmate! #{player1.name} won the game!"
          return true
        elsif check
          puts "check!"
          @check = true
          false
        end
      end
    end

  end

  def check?
    return true if @check == true
  end

  def breaks_chessmate?
    if next_turn_player
      color = next_turn_player.color
      king_symbol = color == 'white' ? "\u2654 " : "\u265A "
    end

    king_moves = []

    king = board.chesspiece.values.select { |chesspiece| chesspiece && chesspiece.symbol == king_symbol }
    king.each { |chesspiece| king_moves << chesspiece.all_moves && king_moves << [chesspiece.current_position] }

    # puts " king_moves = #{king_moves}"

    opponent_chesspiece = board.chesspiece.values.select do |chesspiece|
      chesspiece && chesspiece.color != color && (chesspiece.all_moves & king_moves.flatten(1)).any? 
    end
    
    
    @opponent_chesspiece_moves = opponent_chesspiece.map(&:way_to_king).compact.flatten(1)

    # puts "opponent_chesspiece_moves = #{opponent_chesspiece_moves}" 

    @opponent_way_to_king_cells = board.cell_names.select do |key, value|
      opponent_chesspiece_moves.include?(value) && !(board.chesspiece[key] && 
      [ "\u2654 ", "\u265A " ].include?(board.chesspiece[key].symbol))
    end.keys

    # puts "opponent_way_to_king_cells = #{opponent_way_to_king_cells}"

    defending_chesspieces = board.chesspiece.values.select do |chesspiece|
      chesspiece && chesspiece.color == color && (chesspiece.all_moves & opponent_chesspiece_moves).any?
    end

    @defending_chesspieces_cells = []
    defending_chesspieces.each do |object|
      if object.symbol != "\u2654 " && object.symbol != "\u265A "

        @defending_chesspieces_cells << object.starting_position_cell
      end
    end
    
    # puts "defending_chesspieces_cells = #{defending_chesspieces_cells}"

    defending_chesspieces_moves = defending_chesspieces.map(&:all_moves).flatten(1)

    # puts "defending_chesspieces_moves = #{defending_chesspieces_moves}"
    
    king_escape = []
    if color == 'white'
      king_escape << (board.white_king_moves - opponent_chesspiece_moves)
    else
      king_escape << (board.black_king_moves - opponent_chesspiece_moves)
    end

    king_escape_flattened = king_escape.flatten(1)
    @king_escape_moves = board.cell_names.select do |key, value|
      king_escape_flattened.include?(value)
    end.keys
    
    # puts "king_escape_moves = #{@king_escape_moves}"
    # puts "king_escape = #{king_escape.flatten(1)}"
  end


  def introduction
    puts <<~HEREDOC
      
    Welcome to the Chess!

    If you wish to SAVE the game at any tyme please type SAVE instead of selecting chesspiece you want to move.

    Please select players names!

    HEREDOC
  end
end