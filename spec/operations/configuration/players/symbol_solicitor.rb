require_relative '../../../../lib/operations/configuration/main'

RSpec.describe Players::Configuration::SymbolSolicitor do
  before do
    allow(interface).to receive(:prompt).and_return(*script)
    allow(interface).to receive(:display)
  end

  subject do
    Players::Configuration::SymbolSolicitor.new(interface: interface, symbols: symbols)
  end
  context 'valid' do
    let(:script) { [valid_symbol] }
    it 'prompt' do
      expect(interface).to receive(:display).with(basic_prompt).once
      subject.ask
    end
    it 'error prompt' do
      expect(interface).not_to receive(:display).with(error_prompt)
      subject.ask
    end
    it 'returns last response' do
      expect(subject.ask).to eq valid_symbol
    end
  end
  context 'invalid valid' do
    let(:script) { ['5', valid_symbol] }
    it 'prompt' do
      expect(interface).to receive(:display).with(basic_prompt).once
      subject.ask
    end
    it 'error prompt' do
      expect(interface).to receive(:display).with(error_prompt).once
      subject.ask
    end
    it 'returns last response' do
      expect(subject.ask).to eq valid_symbol
    end
  end
  context 'valid' do
    let(:script) { ['A', 'j', valid_symbol] }
    it 'prompt' do
      expect(interface).to receive(:display).with(basic_prompt).once
      subject.ask
    end
    it 'error prompt' do
      expect(interface).to receive(:display).with(error_prompt).twice
      subject.ask
    end
    it 'returns last response' do
      expect(subject.ask).to eq valid_symbol
    end
  end

  let(:basic_prompt) { player_cell.present_symbol([], symbols) }
  let(:error_prompt) do
    player_cell.present_symbol([player_cell.symbol_error_msg], symbols)
  end
  let(:valid_symbol) { symbols.sample }
  let(:symbols) { Players.new.available_symbols }
  let(:player_cell) { Players::Cell.new }
  let(:interface) { CommandLineInterface.new }
end
