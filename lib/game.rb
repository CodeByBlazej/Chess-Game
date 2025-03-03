require_relative 'game/players'
require_relative 'game/board'
require_relative 'game/knight'
require_relative 'game/rook'
require_relative 'game/bishop'
require 'pry-byebug'

class Game
  attr_reader :board, :player1_name, :player2_name, :player1, :player2, :white_chesspieces_positions, :black_chesspieces_positions

  def initialize
    @board = Board.new
    @white_chesspieces_positions = {}
    @black_chesspieces_positions = {}
  end

  def play_game
    introduction
    create_players
    # play_round
    board.display_board
    puts board.board[0][1]
    puts board.board[1][0]
    # board.name_cells
    create_chesspieces_and_add_to_board('white')
    create_chesspieces_and_add_to_board('black')
    # binding.pry

    board.display_board

    # create chesspieces - colors and their coordinates
  end

  def create_players
    puts 'Player 1, what is your name?'
    @player1_name = gets.chomp
    puts 'Player 2, what is your name?'
    @player2_name = gets.chomp

    @player1 = Players.new(player1_name)
    @player2 = Players.new(player2_name)
  end

  def create_chesspieces_and_add_to_board(color)
    create_chesspieces_positions(color)

    # @knight = Knight.new(color, "\u2658 ")

    # board.board[0][1] = @knight.symbol
    color == 'white' ? col_pos = white_chesspieces_positions : col_pos = black_chesspieces_positions

    col_pos.each_pair do |key, values|
      case key
      when :rook
        values.each do |value|
          rook = Rook.new(color, value)
          board.board[board.cell_names[value][0]][board.cell_names[value][1]] = rook.symbol 
        end
      when :knight
        values.each do |value|
          knight = Knight.new(color, value)
          board.board[board.cell_names[value][0]][board.cell_names[value][1]] = knight.symbol
        end
      when :bishop
        values.each do |value|
          bishop = Bishop.new(color, value)
          board.board[board.cell_names[value][0]][board.cell_names[value][1]] = bishop.symbol
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
    board.board[0][0] = "\u2655 "
    board.board[0][2] = "\u265A "
    board.board[0][3] = "\u2654 "
    board.board[0][5] = "\u265A "


  end

  def introduction
    puts <<~HEREDOC
      
    Welcome to the Chess!

    Please select players names!

    HEREDOC
  end
end