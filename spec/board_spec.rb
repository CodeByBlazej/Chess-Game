require_relative '../lib/game/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#name_cells' do
    it 'gives each cell a name and saves it in hash' do
      board.name_cells
      expect(board.cell_names['A1']).to eq([0, 0])
      expect(board.cell_names['B1']).to eq([1, 0])
      expect(board.cell_names['F8']).to eq([5, 7])
      expect(board.cell_names['H4']).to eq([7, 3])
      expect(board.cell_names['D5']).to eq([3, 4])
    end
  end
end