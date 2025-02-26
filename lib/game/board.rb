require_relative '../game'

class Board
  attr_reader :board, :white, :black

  def initialize 
    @board = Array.new(8) { Array.new(8, '  ') }
    @white = "\e[47m"
    @black = "\e[40m"

  end

  def display_board
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
end