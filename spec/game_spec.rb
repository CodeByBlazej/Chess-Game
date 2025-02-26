require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#create_players' do
    
    before do
      allow(game).to receive(:gets)  
    end

    it 'asks for names and creates 2 objects' do
      expect(Players).to receive(:new).twice
      game.create_players 
    end
  end
end