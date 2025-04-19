require_relative 'lib/game'

def introduction
  puts <<~HEREDOC
    
  Welcome to the Chess!

  If you wish to SAVE the game at any tyme please type SAVE instead of selecting chesspiece you want to move.

  Do you want to load a game? (YES or NO)

  HEREDOC
end

introduction

answer = gets.chomp.upcase

until %w[YES NO].include?(answer)
  puts 'You made a typo, plase type YES or NO again...'
  answer = gets.chomp.upcase
end

if answer == 'YES' && File.exist?('savegame.json')
  game = Game.load_game('savegame.json')
else
  game = Game.new
end

game.play_game

