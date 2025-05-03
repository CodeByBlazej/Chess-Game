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

  describe 'create_black_king_moves' do
    let(:board) { Board.new }
    let(:piece1) { instance_double('Piece', symbol: "\u265A ", all_moves: [[6, 5], [6, 6]], current_position: [[7, 5]]) }
    let(:piece2) { instance_double('Piece', symbol: "\u265B ", all_moves: [[4, 3]], current_position: [[3, 2]]) }
    let(:piece3) { instance_double('Piece', symbol: "\u265C ", all_moves: [[1, 1]], current_position: [[2, 2]]) }

    before do
      board.chesspiece[:X] = piece1
      board.chesspiece[:Y] = piece2
      board.chesspiece[:Z] = piece3
      board.create_black_king_moves
    end

    it 'collects only BLACK king moves and position flattened' do
      expect(board.black_king_moves).to match_array([[6, 5], [6, 6]])
      expect(board.black_king_position).to match_array([[7, 5]])
    end
  end
end