require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }
  let(:board) { instance_double(Board) }
  let(:rook) { instance_double(Rook, color: 'white', symbol: "\u2656 ")}
  let(:knight) { instance_double(Knight, color: 'white', symbol: "\u2658 ")}
  let(:bishop) { instance_double(Bishop, color: 'white', symbol: "\u2657 ")}
  let(:queen) { instance_double(Queen, color: 'white', symbol: "\u2655 ")}
  let(:king) { instance_double(King, color: 'white', symbol: "\u2654 ")}
  let(:pawn) { instance_double(Pawn, color: 'white', symbol: "\u2659 ")}

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
    let(:board_obj) { Board.new }

    before do
      game.instance_variable_set(:@board, board_obj)
      allow(game).to receive(:board).and_return(board_obj)

      allow(Rook).to receive(:new).and_return(rook)
      allow(Knight).to receive(:new).and_return(knight)
      allow(Bishop).to receive(:new).and_return(bishop)
      allow(Queen).to receive(:new).and_return(queen)
      allow(King).to receive(:new).and_return(king)
      allow(Pawn).to receive(:new).and_return(pawn)

      game.instance_variable_set(:@chesspiece, {})

      game.instance_variable_set(:@white_chesspieces_positions, {
      :rook => [:A1, :H1],
      :knight => [:B1, :G1],
      :bishop => [:C1, :F1],
      :queen => [:D1],
      :king => [:E1],
      :pawn => [:A2, :B2, :C2, :D2, :E2, :F2, :G2, :H2]
      })
    end

    it 'calls Rook.new when creating WHITE pieces' do
      board_obj.name_cells

      expect(Rook).to receive(:new).with('white', :A1, board_obj).at_least(:once)
      game.create_chesspieces_and_add_to_board('white')
    end

    it 'calls Queen.new when creating WHITE pieces' do
      board_obj.name_cells

      expect(Queen).to receive(:new).with('white', :D1, board_obj).at_least(:once)
      game.create_chesspieces_and_add_to_board('white')
    end

    it 'assigns the rook symbol to [7][0] on the board' do
      board_obj.name_cells

      game.create_chesspieces_and_add_to_board('white')
      expect(game.board.board[7][0]).to eq(rook.symbol)
    end

    it 'assigns the queen symbol to [7][3] on the board' do
      board_obj.name_cells

      game.create_chesspieces_and_add_to_board('white')
      expect(game.board.board[7][3]).to eq(queen.symbol)
    end

    it 'assigns every rook object to their cell names' do
      board_obj.name_cells

      game.create_chesspieces_and_add_to_board('white')
      expect(game.board.chesspiece[:A1]).to eq(rook)
      expect(game.board.chesspiece[:H1]).to eq(rook)
    end
  end

  describe '#create_chesspieces_positions' do
    
    it 'creates hash with keys of the WHITE piece name and values of board cell name' do
      hash = {:rook => [:A1, :H1],
              :knight => [:B1, :G1],
              :bishop => [:C1, :F1],
              :queen => [:D1],
              :king => [:E1],
              :pawn => [:A2, :B2, :C2, :D2, :E2, :F2, :G2, :H2]}
      game.create_chesspieces_positions('white')
      expect(game.instance_variable_get(:@white_chesspieces_positions)).to eq(hash)
    end

    it 'creates hash with keys of the BLACK piece name and values of board cell name' do
      hash = {:rook => [:A8, :H8],
              :knight => [:B8, :G8],
              :bishop => [:C8, :F8],
              :queen => [:D8],
              :king => [:E8],
              :pawn => [:A7, :B7, :C7, :D7, :E7, :F7, :G7, :H7]}
      game.create_chesspieces_positions('black')
      expect(game.instance_variable_get(:@black_chesspieces_positions)).to eq(hash)
    end
  end

  describe '#play_round' do
    let(:player1) { player1 }
    let(:player2) { player2 }

    before do
      game.instance_variable_set(:@player1, player1)
      game.instance_variable_set(:@player2, player2)
    end

    context 'when it is 1st round' do
      it 'checks if next_turn_player is nil' do
        expect(game.instance_variable_get(:@next_turn_player)).to eq(nil)
      end
      
      it 'calls #pick_chesspiece with player1' do
        expect(game).to receive(pick_chesspiece).with(player1)
        game.play_round
      end
    end

    context 'when next_turn_player is player1' do
      
      xit 'calls pick_chesspiece(player1) and set next_turn_player to player2' do
        expect(game).to receive(:puts).with('Player')
      end
    end
  end


end