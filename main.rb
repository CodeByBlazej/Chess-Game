require_relative 'lib/game'

def introduction
intro = <<~HEREDOC
    
  #{ "Welcome to the Chess!".colorize(:yellow) }

  #{ "If you wish to SAVE the game at any tyme please type SAVE instead of selecting chesspiece you want to move.".colorize(:green) }

  #{ "Do you want to load a game? (YES or NO)".colorize(:yellow) }

  HEREDOC

  puts intro
end

introduction

answer = gets.chomp.upcase

until %w[YES NO].include?(answer)
  puts 'You made a typo, plase type YES or NO again...'.colorize(:red)
  answer = gets.chomp.upcase
end

if answer == 'YES' && File.exist?('savegame.json')
  game = Game.load_game('savegame.json')
else
  game = Game.new
end

game.play_game

