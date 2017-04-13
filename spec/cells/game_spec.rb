require_relative '../../lib/cells/game'
require_relative '../../lib/operations/configuration/main'

RSpec.describe Game::Cell do
  subject { Game::Cell.new }

  describe '#turn_view' do
    context 'no residual errors' do
      let(:board) do
        bored(['X', '@', 'X',
               '@', nil, 'X',
               '@', 'X', '@'])
      end
      it 'expected string' do
        expected  = "\n"
        expected += " X | @ | X\n"
        expected += "===+===+===\n"
        expected += " @ | 4 | X\n"
        expected += "===+===+===\n"
        expected += " @ | X | @\n"
        expected += "Select your move\n"
        expected += "Options are [4]\n"

        expect(subject.turn_view(state)).to eq expected
      end
      let(:run_config) { { board: board, players: unconfigured_players } }
    end
    context 'residual errors' do
      let(:board) do
        bored(['X', '@', 'X',
               '@', nil, 'X',
               '@', 'X', '@'])
      end
      let(:errors) { ['Whoops, someone screwed up'] }
      it 'expected string' do
        expected = "\n"
        expected += " X | @ | X\n"
        expected += "===+===+===\n"
        expected += " @ | 4 | X\n"
        expected += "===+===+===\n"
        expected += " @ | X | @\n"
        expected += "Whoops, someone screwed up\n"
        expected += "Select your move\n"
        expected += "Options are [4]\n"

        expect(subject.turn_view(state)).to eq expected
      end
      let(:run_config) do
        { board: board, players: unconfigured_players, errors: errors }
      end
    end
  end

  let(:state) { Configuration::Main.test_state(run_config) }
  let(:unconfigured_players) { Players.new }
  def bored(array)
    Board.new(edge: 3).tap do |brd|
      Board.assign_board_state(brd, array)
    end
  end
end
