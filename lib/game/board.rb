require_relative '../game'

class Board
  attr_reader :board

  def initialize board
    @board = board
  end

  def color_board
    board.each_with_index do |row, idx|
      row.map! { |el| idx.even? ? el = "\e[47m" : el = "\e[40m" }
    end
  end

  def display_board
    color_board
    board.each_with_index do |row, idx|
      print 8 - idx
      print row.join
      puts "\n  ----------------------"
    end
    puts "  a  b  c  d  e  f  g  h"
  end
end