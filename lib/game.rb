require_relative 'game/players'
require_relative 'game/board'
require_relative 'game/knight'
require 'pry-byebug'

class Game
  attr_reader :board, :player1_name, :player2_name, :player1, :player2

  def initialize
    @board = Board.new

  end

  def play_game
    introduction
    create_players
    play_round
    board.display_board
    puts board.board[0][1]
    puts board.board[1][0]
    # board.name_cells
    create_chesspieces
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

  def create_chesspieces
    # binding.pry
    board.board[0][1] = board.knight.symbol
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