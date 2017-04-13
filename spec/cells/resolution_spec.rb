require_relative '../../lib/operations/resolution'
require_relative '../../lib/operations/configuration/main'

RSpec.describe Resolution::Cell do
  subject { Resolution::Cell.new }

  describe '#win_msg' do
    context 'count is even (p2 took winning move)' do
      let(:count) { 6 }
      it 'expected string' do
        expected  = "\n"
        expected += " X | @ | X\n"
        expected += "===+===+===\n"
        expected += " @ | 4 | X\n"
        expected += "===+===+===\n"
        expected += " @ | X | @\n"
        expected += "Game over\n"
        expected += "Congratulations!!! #{p2_sym}\n"

        expect(subject.win_msg(state)).to eq expected
      end
    end
    context 'count is odd (p1 took winning move)' do
      let(:count) { 7 }
      it 'expected string' do
        expected = "\n"
        expected += " X | @ | X\n"
        expected += "===+===+===\n"
        expected += " @ | 4 | X\n"
        expected += "===+===+===\n"
        expected += " @ | X | @\n"
        expected += "Game over\n"
        expected += "Congratulations!!! #{p1_sym}\n"

        expect(subject.win_msg(state)).to eq expected
      end
    end
    let(:run_config) { { players: players, count: count, board: board } }
    let(:board) do
      bored(['X', '@', 'X',
             '@', nil, 'X',
             '@', 'X', '@'])
    end
    let(:p1_sym) { 'X' }
    let(:p2_sym) { '@' }
    let(:players) do
      Players.new.tap do |players|
        players.add(symbol: p1_sym, type: :human)
        players.add(symbol: p2_sym, type: :hard)
      end
    end
  end

  describe '#draw_msg' do
    it 'expected string' do
      expected  = "\n"
      expected += " X | @ | X\n"
      expected += "===+===+===\n"
      expected += " @ | 4 | X\n"
      expected += "===+===+===\n"
      expected += " @ | X | @\n"
      expected += "Game over\n"
      expected += "Good game, better luck next time\n"

      expect(subject.draw_msg(state)).to eq expected
    end
    let(:board) do
      bored(['X', '@', 'X',
             '@', nil, 'X',
             '@', 'X', '@'])
    end
    let(:run_config) { { board: board, players: unconfigured_players } }
  end

  let(:state) { Configuration::Main.test_state(run_config) }
  let(:unconfigured_players) { Players.new }
  def bored(array)
    Board.new(edge: 3).tap do |brd|
      Board.assign_board_state(brd, array)
    end
  end
end
