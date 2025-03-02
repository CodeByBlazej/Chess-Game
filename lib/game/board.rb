require_relative '../game'

class Board
  attr_reader :board, :white, :black, :knight, :cell_names

  def initialize 
    @board = Array.new(8) { Array.new(8, '  ') }
    @white = "\e[0;100m"
    @black = "\e[40m"
    # @knight = Knight.new('white', "\u2658 ")
    @cell_names = {}
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

end