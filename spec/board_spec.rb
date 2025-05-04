require_relative '../lib/game/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#name_cells' do
    before do
      board.name_cells
    end

    it 'gives each cell a name and saves it in hash' do
      expect(board.cell_names[:A1]).to eq([7, 0])
      expect(board.cell_names[:B1]).to eq([7, 1])
      expect(board.cell_names[:F8]).to eq([0, 5])
      expect(board.cell_names[:H4]).to eq([4, 7])
      expect(board.cell_names[:D5]).to eq([3, 3])
    end

    it 'creates 64 distinct entries' do
      expect(board.cell_names.keys.size).to eq(64)
      expect(board.cell_names.values.uniq.size).to eq(64)
    end
  end

  describe '#create_black_chesspieces_moves' do
    let(:board) { Board.new }
    let(:piece1) { instance_double('Piece', color: 'black', all_moves: [[0, 1], [1, 1]]) }
    let(:piece2) { instance_double('Piece', color: 'black', all_moves: [[2, 2]]) }
    let(:piece3) { instance_double('Piece', color: 'white', all_moves: [[3, 3]]) }

    before do
      board.chesspiece[:X] = piece1
      board.chesspiece[:Y] = piece2
      board.chesspiece[:Z] = piece3
      board.create_black_chesspieces_moves
    end

    it 'collects only BLACK pieces moves, flattened' do
      expect(board.black_chesspieces_moves).to match_array([[0, 1], [1, 1], [2, 2]])
    end
  end

  describe '#create_white_chesspieces_moves' do
    let(:board) { Board.new }
    let(:piece1) { instance_double('Piece', color: 'white', all_moves: [[6, 5], [6, 6]]) }
    let(:piece2) { instance_double('Piece', color: 'white', all_moves: [[4, 3]]) }
    let(:piece3) { instance_double('Piece', color: 'black', all_moves: [[1, 1]]) }

    before do
      board.chesspiece[:X] = piece1
      board.chesspiece[:Y] = piece2
      board.chesspiece[:Z] = piece3
      board.create_white_chesspieces_moves
    end

    it 'collects only WHITE pieces moves, flattened' do
      expect(board.white_chesspieces_moves).to match_array([[6, 5], [6, 6], [4, 3]])
    end
  end

  describe '#create_black_king_moves' do
    let(:board) { Board.new }
    let(:piece1) { instance_double('Piece', symbol: "\u265A ", all_moves: [[0, 5], [1, 4]], current_position: [[0, 4]]) }
    let(:piece2) { instance_double('Piece', symbol: "\u265B ", all_moves: [[3, 0], [3, 1]], current_position: [[3, 2]]) }
    let(:piece3) { instance_double('Piece', symbol: "\u265C ", all_moves: [[0, 1]], current_position: [[0, 0]]) }

    before do
      board.chesspiece[:X] = piece1
      board.chesspiece[:Y] = piece2
      board.chesspiece[:Z] = piece3
      board.create_black_king_moves
    end

    it 'collects only BLACK king moves and position flattened' do
      expect(board.black_king_moves).to match_array([[0, 5], [1, 4]])
      expect(board.black_king_position).to match_array([[0, 4]])
    end
  end

  describe '#create_white_king_moves' do
    let(:board) { Board.new }
    let(:piece1) { instance_double('Piece', symbol: "\u2654 ", all_moves: [[6, 3], [7, 3]], current_position: [[7, 4]]) }
    let(:piece2) { instance_double('Piece', symbol: "\u2655 ", all_moves: [[4, 2], [3, 2]], current_position: [[5, 2]]) }
    let(:piece3) { instance_double('Piece', symbol: "\u2656 ", all_moves: [[6, 0]], current_position: [[7, 0]]) }

    before do
      board.chesspiece[:X] = piece1
      board.chesspiece[:Y] = piece2
      board.chesspiece[:Z] = piece3
      board.create_white_king_moves
    end

    it 'collects only WHITE king moves and position flattened' do
      expect(board.white_king_moves).to match_array([[6, 3], [7, 3]])
      expect(board.white_king_position).to match_array([[7, 4]])
    end
  end

  describe 'JSON round-trip' do
    let(:board) do
      Board.new.tap do |b|
        b.name_cells
        # put a rook and a pawn on two squares
        b.chesspiece[:A1] = Rook.new('black', :A1, b)
        b.chesspiece[:H2] = Pawn.new('white', :H2, b)
        b.board[b.cell_names[:A1][0]][b.cell_names[:A1][1]] = b.chesspiece[:A1].symbol
        b.board[b.cell_names[:H2][0]][b.cell_names[:H2][1]] = b.chesspiece[:H2].symbol
      end
    end

    it 'to_json → from_json reconstructs the grid and the pieces' do
      json_str = board.to_json
      hash     = JSON.parse(json_str)

      board2 = Board.from_json(hash)
  
      # 1. same raw board array
      expect(board2.board).to eq(board.board)
  
      # 2. same cell_names mapping
      expect(board2.cell_names).to eq(board.cell_names)
  
        # 3. two pieces in the same places
      expect(board2.chesspiece[:A1].class).to be(Rook)
      expect(board2.chesspiece[:A1].color).to eq('black')
      expect(board2.chesspiece[:H2].class).to be(Pawn)
      expect(board2.chesspiece[:H2].color).to eq('white')
  
      # 4. the back‐pointer to board is reset
      expect(board2.chesspiece[:A1].board).to be(board2)
      expect(board2.chesspiece[:H2].board).to be(board2)
    end
  end
end