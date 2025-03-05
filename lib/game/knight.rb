require_relative '../game'

class Knight
  attr_reader :color, :symbol, :starting_position, :current_position

  def initialize color, starting_position, board
    @board = board
    @color = color
    @symbol = color == 'white' ? "\u2658 " : "\u265E "
    @starting_position = starting_position
    @current_position = starting_position
    # @test_cur_pos = 
  end

  def available_moves
    moves = [-2, -1, 1, 2].shuffle
    allowed_moves = moves.permutation(2).reject { |a, b| (a + b).zero? }
    potential_moves = allowed_moves.map { |a, b| [a + current_position[0], b + current_position[1]] }
    potential_moves.select do |a, b|
      a >= 0 && a <= 7 && b >= 0 && b <= 7
    end
  end

  def test_display
    puts @starting_position
    p @starting_position
    puts @current_position
    p @current_position
    # available_moves
    p @board.cell_names[:B1]
    # think about changing how game creates each object. instead of 
    # passing starting position pass only board and then in each object
    # make starting position out of board.cell_names where needed
  end
end
