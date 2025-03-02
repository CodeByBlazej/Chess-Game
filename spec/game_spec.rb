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

  describe '#create_chesspieces_and_add_to_board' do

    before do
      allow(Knight).to receive(:new).and_return(knight)
    end

    it 'calls Knight.new when creating WHITE pieces' do
      expect(Knight).to receive(:new).with('white', knight.symbol).at_least(:once)
      game.create_chesspieces_and_add_to_board('white')
    end

    it 'assigns the knight symbol to [0][1] on the board' do
      game.create_chesspieces_and_add_to_board('white')
      expect(game.board.board[0][1]).to eq(knight.symbol)
    end
  end

  describe '#create_chesspieces_positions' do
    
    it 'creates hash with key of the piece name and value of board cell name' do
      hash = {:knight => [:B1, :G1]}
      game.create_chesspieces_positions('white')
      expect(game.instance_variable_get(:@white_chesspieces_positions)).to eq(hash)
    end
  end


end