require_relative 'game/players'
require_relative 'game/board'

class Game
  attr_reader :board

  def initialize
    @board = Board.new(Array.new(8) { Array.new(8) })

  end

  def play_game
    board.display_board
  end
end