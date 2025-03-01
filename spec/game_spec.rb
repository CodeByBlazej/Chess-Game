require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }
  let(:board) { instance_double(Board) }
  let(:knight) { instance_double(Knight, color: 'white', symbol: "\u2658 ")}

  describe '#create_players' do
    
    before do
      player1_name = 'Tim'
      player2_name = 'Rob'
      allow(game).to receive(:gets).and_return(player1_name, player2_name)
      allow(game).to receive(:puts)
    end

    it 'asks for names and creates 2 objects' do
      expect(Players).to receive(:new).twice
      game.create_players 
    end
  end

  describe '#create_chesspieces' do


    it 'create objects for WHITE chess pieces' do
      expect(Knight).to receive(:new).twice
      game.create_chesspieces('white')
      # expect(game.board.board[0][1]).to eq(knight.symbol)
    end
  end


end