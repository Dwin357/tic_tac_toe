require_relative '../../../../lib/operations/configuration/main'

RSpec.describe Players::Configuration::TypeSolicitor do
  before do
    allow(interface).to receive(:prompt).and_return(*script)
    allow(interface).to receive(:display)
  end

  subject { Players::Configuration::TypeSolicitor.new(interface: interface) }

  context 'human' do
    let(:script) { ['human'] }
    it 'prompt' do
      expect(interface).to receive(:display).with(basic_prompt).once
      subject.ask
    end
    it 'error prompt' do
      expect(interface).not_to receive(:display).with(error_prompt)
      subject.ask
    end
    it 'returns last response as symbol' do
      expect(subject.ask).to eq :human
    end
  end
  context 'hard' do
    let(:script) { ['hard'] }
    it 'prompt' do
      expect(interface).to receive(:display).with(basic_prompt).once
      subject.ask
    end
    it 'error prompt' do
      expect(interface).not_to receive(:display).with(error_prompt)
      subject.ask
    end
    it 'returns last response as symbol' do
      expect(subject.ask).to eq :hard
    end
  end
  context 'easy' do
    let(:script) { ['easy'] }
    it 'prompt' do
      expect(interface).to receive(:display).with(basic_prompt).once
      subject.ask
    end
    it 'error prompt' do
      expect(interface).not_to receive(:display).with(error_prompt)
      subject.ask
    end
    it 'returns last response as symbol' do
      expect(subject.ask).to eq :easy
    end
  end
  context 'medium' do
    let(:script) { ['medium'] }
    it 'prompt' do
      expect(interface).to receive(:display).with(basic_prompt).once
      subject.ask
    end
    it 'error prompt' do
      expect(interface).not_to receive(:display).with(error_prompt)
      subject.ask
    end
    it 'returns last response as symbol' do
      expect(subject.ask).to eq :medium
    end
  end
  context 'garbage human' do
    let(:script) { %w(garbage human) }
    it 'prompt' do
      expect(interface).to receive(:display).with(basic_prompt).once
      subject.ask
    end
    it 'error prompt' do
      expect(interface).to receive(:display).with(error_prompt).once
      subject.ask
    end
    it 'returns last response as symbol' do
      expect(subject.ask).to eq :human
    end
  end
  context 'blah garbage easy' do
    let(:script) { %w(blah garbage easy) }
    it 'prompt' do
      expect(interface).to receive(:display).with(basic_prompt).once
      subject.ask
    end
    it 'error prompt' do
      expect(interface).to receive(:display).with(error_prompt).twice
      subject.ask
    end
    it 'returns last response as symbol' do
      expect(subject.ask).to eq :easy
    end
  end

  let(:basic_prompt) { player_cell.present_type([]) }
  let(:error_prompt) { player_cell.present_type([player_cell.type_error_msg]) }
  let(:player_cell) { Players::Cell.new }
  let(:interface) { CommandLineInterface.new }
end
