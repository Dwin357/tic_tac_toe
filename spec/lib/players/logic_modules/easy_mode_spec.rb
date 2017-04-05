require_relative '../../../../lib/players/logic_modules/easy_mode'
require_relative '../../../../lib/board'

class TestEasy
  include EasyMode
end

RSpec.describe TestEasy do
  subject { TestEasy.new }

  describe '#real_move' do
    let(:board) do
      board_matching(%w(0 X 2
                        X O O
                        6 7 8))
    end
    it 'returns a random open move' do
      expect(subject.real_move(board, players))
        .to satisfy { |sbj| [0, 2, 6, 7, 8].include?(sbj) }
    end

    let(:players) { SecureRandom.uuid }
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
    it 'identifies as EasyMode' do
      expect(subject.send(:module_id)).to eq EasyMode
    end
  end
end
