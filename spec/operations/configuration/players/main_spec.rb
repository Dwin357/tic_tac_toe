require_relative '../../../../lib/operations/configuration/main'

RSpec.describe Players::Configuration::Main do
  subject { Players::Configuration::Main.new }

  before { allow(interface).to receive(:display) }

  describe 'object creation' do
    it 'loads a players' do
      expect(subject.players).to be_a Players
    end
    it 'loads a cell' do
      expect(subject.cell).to be_a Players::Cell
    end
  end

  describe '#configured_players' do
    before do
      allow(subject).to receive(:player_arg).and_return(arg1, arg2)
    end
    it 'returns a players object' do
      expect(subject.configured_players(protostate)).to be_a Players
    end
    describe 'player 1' do
      let(:player_one) { subject.configured_players(protostate).active_player(0) }
      it 'right symbol' do
        expect(player_one.symbol).to eq arg1[:symbol]
      end
      it 'right type' do
        expect(player_one).to be_a HumanPlayer
      end
      it 'has an interface' do
        expect(player_one.send(:interface)).not_to be nil
      end
    end
    describe 'player 2' do
      let(:player_two) { subject.configured_players(protostate).active_player(1) }
      it 'right symbol' do
        expect(player_two.symbol).to eq arg2[:symbol]
      end
      it 'right type' do
        expect(player_two).to be_a HardPlayer
      end
      it 'has an interface' do
        expect(player_two.send(:interface)).not_to be nil
      end
    end
    it 'displays title for each player' do
      expect(interface).to receive(:display).with(cell.player_one_title).once
      expect(interface).to receive(:display).with(cell.player_two_title).once
      subject.configured_players(protostate)
    end
    let(:arg1) { { symbol: '*', type: :human, interface: interface } }
    let(:arg2) { { symbol: '@', type: :hard, interface: interface } }
  end

  describe '#player_arg' do
    before do
      allow_any_instance_of(Players::Configuration::TypeSolicitor)
        .to receive(:ask).and_return(:human)
      allow_any_instance_of(Players::Configuration::SymbolSolicitor)
        .to receive(:ask).and_return('@')
    end
    it 'passes expected arg to TypeSolicitor' do
      arg = { interface: interface, symbols: subject.players.available_symbols }
      expect(Players::Configuration::TypeSolicitor).to receive(:new)
        .with(arg).once.and_call_original
      subject.player_arg(protostate)
    end
    it 'passes expected arg to SymbolSolicitor' do
      arg = { interface: interface, symbols: subject.players.available_symbols }
      expect(Players::Configuration::SymbolSolicitor).to receive(:new)
        .with(arg).once.and_call_original
      subject.player_arg(protostate)
    end
    it 'returns player arg' do
      expected = { symbol: '@', type: :human, interface: interface }
      expect(subject.player_arg(protostate)).to eq(expected)
    end
  end

  let(:cell) { Players::Cell.new }
  let(:interface) { CommandLineInterface.new }
  let(:base_config) { { players: false, interface: interface } }
  let(:protostate) do
    Configuration::Main.test_state(base_config)
  end
end
