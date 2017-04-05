require_relative '../../../../lib/players/logic_modules/medium_mode'
require_relative '../../../../lib/players/players'
require_relative '../../../../lib/board'

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
      let(:board) do
        board_matching(%w(0 1 2
                          3 4 5
                          6 7 8))
      end
      it 'returns 4 (ie middle index)' do
        expect(subject.real_move(board, players)).to eq 4
      end
    end
    context 'when computer can win in 1 move' do
      let(:board) do
        board_matching(%w(O O X
                          3 O X
                          6 7 8))
      end
      it 'returns the winning move (ie 8)' do
        expect(subject.real_move(board, players)).to eq 8
      end
    end
    context 'when opponent can win in 1 move' do
      let(:board) do
        board_matching(%w(0 1 X
                          3 O X
                          6 7 O))
      end
      it 'returns the winning move (ie 0)' do
        expect(subject.real_move(board, players)).to eq 0
      end
    end
    context 'with no immediate win and a taken center' do
      let(:board) do
        board_matching(%w(0 X 2
                          X O O
                          6 7 8))
      end
      it 'returns a random open move' do
        sbj = subject.real_move(board, players)
        sleep(1)
        expect(sbj).to satisfy { |sbj| [0, 2, 6, 7, 8].include?(sbj) }
      end
    end

    def board_matching(input)
      board = Board.new
      input.each_with_index do |el, i|
        next if i.to_s == el
        board.select(i, el)
      end
      board
    end
  end

  describe '#module_id' do
    subject { TestMedium.new }
    it 'identifies as MediumMode' do
      expect(subject.send(:module_id)).to eq MediumMode
    end
  end

  let(:players) do
    Players.new.tap do |players|
      players.add(symbol: 'O', type: :human)
      players.add(symbol: 'X', type: :easy)
    end
  end
end
