require_relative '../../../../lib/models/players/logic_modules/medium_mode'
require_relative '../../../../lib/models/players/players'
require_relative '../../../../lib/models/board'

class TestMedium
  include MediumMode
  # parent methods this module depends upon
  def symbol; end
end

RSpec.describe TestMedium do
  subject { TestMedium.new }

  before { allow(subject).to receive(:symbol).and_return('X') }

  describe '#real_move' do
    context 'when middle of the board is open' do
      let(:board_state) do
        [nil, nil, nil,
         nil, nil, nil,
         nil, nil, nil]
      end
      it 'returns 4 (ie middle index)' do
        expect(subject.real_move(board, players)).to eq 4
      end
    end
    context 'when computer can win in 1 move' do
      let(:board_state) do
        ['@', '@', 'X',
         nil, '@', 'X',
         nil, nil, nil]
      end
      it 'returns the winning move (ie 8)' do
        expect(subject.real_move(board, players)).to eq 8
      end
    end
    context 'when opponent can win in 1 move' do
      let(:board_state) do
        [nil, nil, 'X',
         nil, '@', 'X',
         nil, nil, '@']
      end
      it 'returns the winning move (ie 0)' do
        expect(subject.real_move(board, players)).to eq 0
      end
    end
    context 'with no immediate win and a taken center' do
      let(:board_state) do
        [nil, 'X', nil,
         'X', '@', '@',
         nil, nil, nil]
      end
      it 'returns a random open move' do
        sbj = subject.real_move(board, players) # until sbj
        # sleep(1)
        expect(sbj).to satisfy { |sbjj| [0, 2, 6, 7, 8].include?(sbjj) }
      end
    end
  end

  describe '#module_id' do
    subject { TestMedium.new }
    it 'identifies as MediumMode' do
      expect(subject.send(:module_id)).to eq MediumMode
    end
  end

  let(:board) do
    Board.new(edge: 3).tap do |brd|
      Board.assign_board_state(brd, board_state)
    end
  end
  let(:players) do
    Players.new.tap do |players|
      players.add(symbol: '@', type: :human)
      players.add(symbol: 'X', type: :easy)
    end
  end
end
