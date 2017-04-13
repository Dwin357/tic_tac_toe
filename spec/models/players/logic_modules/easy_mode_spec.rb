require_relative '../../../../lib/models/players/logic_modules/easy_mode'
require_relative '../../../../lib/models/board'

class TestEasy
  include EasyMode
end

RSpec.describe TestEasy do
  subject { TestEasy.new }

  describe '#real_move' do
    let(:board_state) do
      [nil, 'X', nil,
       'X', '@', '@',
       nil, nil, nil]
    end
    it 'returns a random open move' do
      expect(subject.real_move(board, players))
        .to satisfy { |sbj| [0, 2, 6, 7, 8].include?(sbj) }
    end

    let(:players) { junk }
    let(:board) do
      Board.new(edge: 3).tap do |brd|
        Board.assign_board_state(brd, board_state)
      end
    end
  end

  describe '#module_id' do
    it 'identifies as EasyMode' do
      expect(subject.send(:module_id)).to eq EasyMode
    end
  end
end
