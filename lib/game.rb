require_relative 'game/players'
require_relative 'game/board'
require_relative 'game/knight'
require_relative 'game/rook'
require_relative 'game/bishop'
require_relative 'game/queen'
require_relative 'game/king'
require_relative 'game/pawn'
require 'pry-byebug'

class Game
  attr_reader :board, :player1_name, :player2_name, :player1, :player2, :white_chesspieces_positions, :black_chesspieces_positions, :chesspiece_to_move, :cell_to_go, :next_turn_player

  def initialize
    @board = Board.new
    @white_chesspieces_positions = {}
    @black_chesspieces_positions = {}
    @chesspiece_to_move = nil
    @cell_to_go = nil
    @next_turn_player = nil
  end

  def play_game
    introduction
    create_players
    board.display_board
    create_chesspieces_and_add_to_board('white')
    create_chesspieces_and_add_to_board('black')
    board.display_board
    play_round
    binding.pry
    play_round
    # board.display_board
    # play_round until end_game?
    # in play_game player is asked what chesspiece he picks up
    # then he he asked where he wants to move
    # binding.pry
    # board.chesspiece[:B1].test_display
    # chesspiece[:G1].test_display
    # chesspiece[:B8].test_display
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
          bishop = Bishop.new(color, value)
          board.chesspiece[value] = bishop
          board.board[board.cell_names[value][0]][board.cell_names[value][1]] = bishop.symbol
        end
      when :queen
        values.each do |value|
          queen = Queen.new(color, value)
          board.chesspiece[value] = queen
          board.board[board.cell_names[value][0]][board.cell_names[value][1]] = queen.symbol
        end
      when :king
        values.each do |value|
          king = King.new(color, value)
          board.chesspiece[value] = king
          board.board[board.cell_names[value][0]][board.cell_names[value][1]] = king.symbol
        end
      when :pawn
        values.each do |value|
          pawn = Pawn.new(color, value)
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

    until board.chesspiece[selected_chesspiece].color == player.color do
      if board.chesspiece[selected_chesspiece].nil?
        puts "You made a typo! Please try again..."
        selected_chesspiece = gets.chomp.to_sym
      elsif board.chesspiece[selected_chesspiece].color != player.color
        puts "You cannot move your opponent chesspieces! Select one of yours..."
        selected_chesspiece = gets.chomp.to_sym
      end
    end

    @chesspiece_to_move = selected_chesspiece
    pick_cell(player)
  end

  def pick_cell(player)
    puts "#{player.name} select field you want to go - for example B3 or F4"
    selected_cell = gets.chomp.to_sym

    until board.cell_names.keys.any?(selected_cell) do
      puts "You made a typo! Please try again..."
      selected_cell = gets.chomp.to_sym
    end

    @cell_to_go = board.cell_names[selected_cell]
    make_move(player)
  end

  def make_move(player)
    board.chesspiece[chesspiece_to_move].moves(cell_to_go)

    until board.chesspiece[chesspiece_to_move].nil? do
      pick_cell(player)
    end

    board.display_board
  end

  def introduction
    puts <<~HEREDOC
      
    Welcome to the Chess!

    Please select players names!

    HEREDOC
  end
end