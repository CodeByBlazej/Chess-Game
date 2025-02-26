require_relative 'game/players'
require_relative 'game/board'

class Game
  attr_reader :board

  def initialize
    @board = Board.new

  end

  def play_game
    introduction
    create_players
    board.display_board
  end

  def introduction
    puts <<~HEREDOC
      
    Welcome to the Chess!

    Please select players names!

    HEREDOC
  end
end