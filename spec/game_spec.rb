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
    let(:player1) { instance_double(Players, color: 'white', name: 'Alice') }
    let(:player2) { instance_double(Players, color: 'black', name: 'Rob') }

    before do
      game.instance_variable_set(:@player1, player1)
      game.instance_variable_set(:@player2, player2)
    end

    context 'When it is 1st round' do
      it 'checks if next_turn_player is nil' do
        expect(game.instance_variable_get(:@next_turn_player)).to eq(nil)
      end
      
      it 'calls #pick_chesspiece with player1' do
        expect(game).to receive(:pick_chesspiece).with(player1)
        game.play_round
      end

      it 'then switches next_turn_player to player2' do
        allow(game).to receive(:pick_chesspiece)
        game.play_round
        expect(game.next_turn_player).to eq(player2)
      end
    end

    context 'When it is 2nd round' do
      before do
        game.instance_variable_set(:@next_turn_player, player2)
        allow(game).to receive(:pick_chesspiece)
      end

      it 'checks if next_turn_player is player2' do
        expect(game.instance_variable_get(:@next_turn_player)).to eq(player2) 
      end

      it 'calls #pick_chesspiece with player2' do
        expect(game).to receive(:pick_chesspiece).with(player2)
        game.play_round
      end

      it 'then switches next_turn_player to player1' do
        game.play_round
        expect(game.next_turn_player).to eq(player1)
      end
    end
  end

  describe '#pick_chesspiece' do
    let(:board) { Board.new }
    let(:game) { Game.new }
    let(:player) { instance_double(Players, name: 'Rob', color: 'white') }
    let(:pawn) { instance_double(Pawn, color: 'white', starting_position_cell: :A1, board: board) }

    before do
      game.instance_variable_set(:@board, board)
      allow(game).to receive(:puts)
      allow(game).to receive(:save_game)
      allow(game).to receive(:pick_cell)

      board.chesspiece[:A1] = pawn

      allow(game).to receive(:can_chesspiece_move?).and_return(false)
      allow(game).to receive(:can_chesspiece_move?).with(:A1).and_return(true)

      allow(game).to receive(:gets).and_return('SAVE', 'A1')
    end

    it 'loops until valid, handles SAVE and sets chesspiece_to_move' do
      expect(game).to receive(:save_game).with('savegame.json')
      expect(game).to receive(:pick_cell).with(player)
      game.pick_chesspiece(player)
      expect(game.chesspiece_to_move).to eq(:A1)
    end
  end

  describe '#can_chesspiece_move?' do
    let(:board) { Board.new }
    let(:game) { Game.new }
    let(:king) { instance_double(King, color: 'white', starting_position_cell: :E1, symbol: "\u2654 ") }
    let(:pawn) { instance_double(Pawn, color: 'white', starting_position_cell: :E2, symbol: "\u2659 ") }
    let(:queen) { instance_double(Queen, color: 'white', starting_position_cell: :D1, symbol: "\u2655 ") }


    context 'There is CHECK and player picked KING that has escape moves available' do
      before do
        game.instance_variable_set(:@board, board)
        game.instance_variable_set(:@check, true)
        
        board.chesspiece[:E1] = king
        
        game.instance_variable_set(:@king_escape_moves, [[7, 4]])
      end
      
      it 'returns true and marks @king_selected' do
        result = game.can_chesspiece_move?(:E1)
        expect(result).to be true
        expect(game.instance_variable_get(:@king_selected)).to be true
      end
    end

    context 'There is CHECK and player picked PAWN that protects the KING' do
      before do
        game.instance_variable_set(:@board, board)
        game.instance_variable_set(:@check, true)

        board.chesspiece[:E2] = pawn

        game.instance_variable_set(:@defending_chesspieces_cells, [:E2])
      end

      it 'returns true' do
        result = game.can_chesspiece_move?(:E2)
        expect(result).to be true
      end
    end

    context 'There is CHECK and player picked PAWN that cannot move' do
      before do
        game.instance_variable_set(:@board, board)
        game.instance_variable_set(:@check, true)

        board.chesspiece[:E2] = pawn

        game.instance_variable_set(:@defending_chesspieces_cells, [])
      end

      it 'returns false' do
        result = game.can_chesspiece_move?(:E2)
        expect(result).to be false
      end
    end

    context 'There is NO CHECK and player picked QUEEN that is free to move' do
      before do
        game.instance_variable_set(:@board, board)
        
        board.chesspiece[:D1] = queen

        allow(board.chesspiece[:D1]).to receive(:available_moves).and_return(true)
        allow(board.chesspiece[:D1]).to receive(:all_moves).and_return([[7, 3]])
      end

      it 'returns true' do
        result = game.can_chesspiece_move?(:D1)
        expect(result).to be true
      end
    end

    context 'Player made mistake and put number of cell that is empty' do
      before do
        game.instance_variable_set(:@board, board)

        board.chesspiece[:A2] = nil
      end

      it 'returns false' do
        result = game.can_chesspiece_move?(:A2)
        expect(result).to be false
      end
    end
  end

  describe '#pick_cell' do
    let(:player) { instance_double(Players, name: 'Rob', color: 'white') }
    let(:board) { Board.new }
    let(:game) { Game.new }

    context 'There is CHECK and player picks cell that block CHECK' do
      before do
        board.name_cells
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return('A1')
        game.instance_variable_set(:@board, board)
        game.instance_variable_set(:@check, true)
        game.instance_variable_set(:@opponent_way_to_king_cells, [:A1])
        allow(game).to receive(:make_move).with(player)
      end

      it 'calls make_move and set @cell_to_go' do
        game.pick_cell(player)
        expect(game.cell_to_go).to eq(board.cell_names[:A1])
      end
    end

    context "There is CHECK and player picks cell that DOESN'T block CHECK" do
      before do
        board.name_cells
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return('A2', 'A1')
        game.instance_variable_set(:@board, board)
        game.instance_variable_set(:@check, true)
        game.instance_variable_set(:@opponent_way_to_king_cells, [:A1])
        allow(game).to receive(:make_move).with(player)
      end

      it 'prompts player to pick another cell' do
        expect(game).to receive(:puts).with('You have to pick the field that would block your king! Please select another one...').once
        game.pick_cell(player)
        expect(game.cell_to_go).to eq(board.cell_names[:A1])
      end
    end

    context "There is CHECK, player has king selected and king HAS cells to escape" do
      before do
        board.name_cells
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return('A2')
        game.instance_variable_set(:@board, board)
        game.instance_variable_set(:@check, true)
        game.instance_variable_set(:@opponent_way_to_king_cells, [])
        game.instance_variable_set(:@king_selected, true)
        game.instance_variable_set(:@king_escape_moves, [:A2])
        allow(game).to receive(:make_move).with(player)
      end

      it 'calls make_move and set @cell_to_go' do
        game.pick_cell(player)
        expect(game.cell_to_go).to eq(board.cell_names[:A2])
      end
    end

    context "There is CHECK, player has king selected and king DOESN'T HAVE cells to escape" do
      before do
        board.name_cells
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return('A1', 'A2')
        game.instance_variable_set(:@board, board)
        game.instance_variable_set(:@check, true)
        game.instance_variable_set(:@opponent_way_to_king_cells, [])
        game.instance_variable_set(:@king_selected, true)
        game.instance_variable_set(:@king_escape_moves, [:A2])
        allow(game).to receive(:make_move).with(player)
      end

      it 'prompts player to pick another cell' do
        expect(game).to receive(:puts).with("You can't move there to escape from check! Select safe field!").once
        game.pick_cell(player)
        expect(game.cell_to_go).to eq(board.cell_names[:A2])
      end
    end

    context "There is NO CHECK, and player picks cell that DOESN'T exist" do
      before do
        board.name_cells
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return('A9', 'B10', 'A2')
        game.instance_variable_set(:@board, board)
        game.instance_variable_set(:@check, nil)
        game.instance_variable_set(:@opponent_way_to_king_cells, [])
        game.instance_variable_set(:@king_selected, nil)
        game.instance_variable_set(:@king_escape_moves, [:A2])
        allow(game).to receive(:make_move).with(player)
      end

      it 'prompts player to pick another cell TWICE' do
        expect(game).to receive(:puts).with("You made a typo! Please try again...").twice
        game.pick_cell(player)
        expect(game.cell_to_go).to eq(board.cell_names[:A2])
      end
    end

    context 'There is NO CHECK, and player picks available cell right away' do
      before do
        board.name_cells
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return('A2')
        game.instance_variable_set(:@board, board)
        game.instance_variable_set(:@check, nil)
        game.instance_variable_set(:@opponent_way_to_king_cells, [])
        game.instance_variable_set(:@king_selected, nil)
        game.instance_variable_set(:@king_escape_moves, [])
        allow(game).to receive(:make_move).with(player)
      end

      it 'calls make_move and set @cell_to_go' do
        game.pick_cell(player)
        expect(game.cell_to_go).to eq(board.cell_names[:A2])
      end
    end
  end

  describe '#make_move' do
    let(:player) { instance_double(Players, name: 'Rob', color: 'white') }
    let(:board) { Board.new }
    let(:game) { Game.new }
    let(:pawn) { instance_double(Pawn, color: 'white', starting_position_cell: :E2, symbol: "\u2659 ") }

    context 'Player picked the right chesspiece that can make move' do
      before do
        game.instance_variable_set(:@board, board)
        game.instance_variable_set(:@chesspiece_to_move, :A2)
        game.instance_variable_set(:@cell_to_go, board.cell_names[:A3])
        board.chesspiece[:A2] = pawn 
        allow(pawn).to receive(:moves).with(board.cell_names[:A3]).and_return(true)
        game.instance_variable_set(:@check, true)
        game.instance_variable_set(:@king_selected, true)
      end

      it 'makes move, set @check and @king_selected to nil and displays board' do
        expect(board).to receive(:display_board)
        game.make_move(player)
        expect(game.instance_variable_get(:@check)).to be_nil
        expect(game.instance_variable_get(:@king_selected)).to be_nil
      end
    end

    context 'Player picked wrong cell' do
      before do
        game.instance_variable_set(:@board, board)
        game.instance_variable_set(:@chesspiece_to_move, :A2)
        game.instance_variable_set(:@cell_to_go, board.cell_names[:A7])
        board.chesspiece[:A2] = pawn
        allow(pawn).to receive(:moves).with(board.cell_names[:A7]).and_return(false)
        game.instance_variable_set(:@check, true)
        game.instance_variable_set(:@king_selected, true)
      end

      it 'calls #pick_chesspiece' do
        expect(game).to receive(:pick_chesspiece).with(player)
        game.make_move(player)
      end
    end
  end

  describe '#chessmate?' do
    let(:board) { Board.new }
    let(:game) { Game.new }
    let(:player1) { instance_double(Players, name: 'Rob', color: 'white') }
    let(:player2) { instance_double(Players, name: 'Tom', color: 'black') }

    context "It's player1 turn and there is check" do
      before do
        game.instance_variable_set(:@board, board)
        allow(board).to receive(:create_black_chesspieces_moves)
        allow(board).to receive(:create_white_chesspieces_moves)
        allow(board).to receive(:create_black_king_moves)
        allow(board).to receive(:create_white_king_moves)
        allow(game).to receive(:prepare_check_data)

        game.instance_variable_set(:@next_turn_player, player1)
        game.instance_variable_set(:@player1, player1)

        allow(board).to receive(:white_king_moves).and_return([[6, 4]])
        allow(board).to receive(:black_chesspieces_moves).and_return([])
        allow(board).to receive(:white_king_position).and_return([7, 4])

        allow(game).to receive(:opponent_chesspiece_moves).and_return([[7, 4]])

        game.instance_variable_set(:@defending_chesspieces_cells, [:F2])
        
        game.instance_variable_set(:@check, nil)
      end

      it "it prompts 'Check!', sets @check to true and returns false" do
        expect(game).to receive(:puts).with("Check!")
        result = game.checkmate?
        expect(result).to eq(false)
        expect(game.instance_variable_get(:@check)).to eq(true)
      end 
    end

    context "It's player1 turn and there is check mate" do
      before do
        game.instance_variable_set(:@board, board)
        allow(board).to receive(:create_black_chesspieces_moves)
        allow(board).to receive(:create_white_chesspieces_moves)
        allow(board).to receive(:create_black_king_moves)
        allow(board).to receive(:create_white_king_moves)
        allow(game).to receive(:prepare_check_data)

        game.instance_variable_set(:@next_turn_player, player1)
        game.instance_variable_set(:@player1, player1)
        game.instance_variable_set(:@player2, player2)

        allow(board).to receive(:white_king_moves).and_return([[6, 4]])
        allow(board).to receive(:black_chesspieces_moves).and_return([[6, 4]])

        allow(board).to receive(:white_king_position).and_return([7, 4])

        allow(game).to receive(:opponent_chesspiece_moves).and_return([[]])
        allow(game).to receive(:king_escape_moves).and_return([])
        game.instance_variable_set(:@defending_chesspieces_cells, [])
        
        game.instance_variable_set(:@check, nil)
      end

      it "it prompts 'Checkmate! player2.name won the game!'and returns true" do
        expect(game).to receive(:puts).with("Checkmate! #{player2.name} won the game!")
        result = game.checkmate?
        expect(result).to eq(true)
      end
    end
  end


end