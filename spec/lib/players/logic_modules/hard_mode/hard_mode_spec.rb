require_relative '../../../../../lib/players/logic_modules/hard_mode/hard_mode'
require_relative '../../../../../lib/players/players'
require_relative '../../../../../lib/board'
require_relative '../../../../../lib/interfaces/command_line_interface'

class TestHard
  include HardMode
  # outside method dependancies of module
  def symbol; end

  def interface; end
end

RSpec.describe TestHard do
  subject { TestHard.new }

  before do
    stub_interface(passed_interface)
    stub_player_symbol(call_sym)
  end

  describe '#module_id' do
    it 'returns HardMode' do
      expect(subject.send(:module_id)).to eq HardMode
    end
  end

  describe '#real_move' do
    context 'with an immediate win move' do
      let(:board) do
        board_matching(%w(@ X @
                          X X @
                          6 7 8))
      end
      it 'returns the winning move' do
        expect(subject.real_move(board, players)).to eq 7
      end
    end
    context 'with an immediate lose move' do
      let(:board) do
        board_matching(%w(@ X @
                          X X @
                          6 @ 8))
      end
      it 'returns the win blocking move' do
        expect(subject.real_move(board, players)).to eq 8
      end
    end
    describe 'ambigious situations' do
      context 'opportunity for forced win' do
        let(:board) do
          board_matching(%w(0 1 @
                            X 4 @
                            6 7 X))
        end
        it 'returns a move which sets up a forced win' do
          expect(subject.real_move(board, players))
            .to satisfy { |sbj| [0, 6].include?(sbj) }
        end
      end
      context 'risk of a forced loss' do
        let(:board) do
          board_matching(%w(@ X 2
                            3 X 5
                            6 @ 8))
        end
        it 'returns a move which blocks forced loss' do
          expect(subject.real_move(board, players))
            .to satisfy { |sbj| [3, 6, 8].include?(sbj) }
        end
      end
    end
    let(:players) { default_players }
  end

  def board_matching(input)
    board = Board.new
    input.each_with_index do |el, i|
      next if i.to_s == el
      board.select(i, el)
    end
    board
  end

  let(:call_sym) { 'X' }
  let(:othr_sym) { '@' }
  let(:default_board) { Board.new }
  let(:default_players) do
    Players.new.tap do |players|
      players.add(symbol: othr_sym, type: :human)
      players.add(symbol: call_sym, type: :hard)
    end
  end
  let(:passed_interface) { CommandLineInterface.new }
  def stub_interface(passed_interface)
    allow(subject).to receive(:interface).and_return(passed_interface)
    allow(passed_interface).to receive(:faux_prompt)
    allow(passed_interface).to receive(:display)
  end

  def stub_player_symbol(sym)
    allow(subject).to receive(:symbol).and_return(sym)
  end
end
