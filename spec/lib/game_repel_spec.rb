require_relative '../../lib/game_repel'

RSpec.describe GameRepel do
  subject { GameRepel.new }

  describe 'object creation' do
    it 'assigns a GameState' do
      expect(subject.send(:game_state)).to be_an_instance_of GameState
    end
  end

  describe '#start_game' do
    before do
      assign_game_state(state)
      allow(passed_interface).to receive(:display) # don't print output to console
    end

    describe 'configuration' do
      before do
        stub_game_state_method('configured?', [false, false, true])
        stub_game_state_method('game_over?',  [true])
        stub_game_state_method('torn_down?',  [true])

        # don't worry about what configuration looks like/means
        allow(state).to receive(:next_configuration)
      end
      it 'calls #next_configuration while #configured? is false' do
        expect(state).to receive(:next_configuration).twice
        subject.start_game
      end
    end

    describe 'game turn' do
      before do
        stub_game_state_method('configured?', [true])
        stub_game_state_method('game_over?',  [false, false, true])
        stub_game_state_method('torn_down?',  [true])

        # don't worry about what game turn looks like/means
        allow(state).to receive(:resolve_turn)
      end
      it 'calls #resolve_turn while #game_over? is false' do
        expect(state).to receive(:resolve_turn).twice
        subject.start_game
      end
    end

    describe 'tear down' do
      before do
        stub_game_state_method('configured?', [true])
        stub_game_state_method('game_over?',  [true])
        stub_game_state_method('torn_down?',  [false, false, true])

        # don't worry about what tear down looks like/means
        allow(state).to receive(:next_tear_down)
      end
      it 'calls #next_tear_down while #torn_down? is false' do
        expect(state).to receive(:next_tear_down).twice
        subject.start_game
      end
    end

    def assign_game_state(state)
      subject.instance_variable_set(:@game_state, state)
    end

    def stub_game_state_method(method_name, response_pattern)
      allow(state).to receive(method_name.to_sym).and_return(*response_pattern)
    end
    let(:passed_interface) { CommandLineInterface.new }
    let(:state) { GameState.new(interface: passed_interface) }
  end
end
