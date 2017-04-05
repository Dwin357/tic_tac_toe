require_relative '../../../lib/interfaces/command_line_interface'

RSpec.describe CommandLineInterface do
  subject { CommandLineInterface.new }

  describe '#display' do
    let(:output) { SecureRandom.uuid }
    it 'puts the output' do
      expect(subject).to receive(:puts).with(output)
      subject.display(output)
    end
  end
  describe '#prompt' do
    before do
      allow(subject).to receive(:print)
      allow(subject).to receive(:gets).and_return(user_response)
    end
    let(:user_response) { SecureRandom.uuid }
    let(:prompt_marker) { SecureRandom.uuid }
    it 'prints prompt marker' do
      expect(subject).to receive(:print).with(prompt_marker)
      subject.prompt(prompt_marker)
    end
    it 'returns users response' do
      expect(subject.prompt(prompt_marker)).to eq user_response
    end
  end
  describe '#faux_prompt' do
    before do
      allow(subject).to receive(:print)
    end
    let(:prompt_marker) { SecureRandom.uuid }
    it 'prints prompt marker' do
      expect(subject).to receive(:print).with(prompt_marker)
      subject.faux_prompt(prompt_marker)
    end
    it 'does not solicite response' do
      expect(subject).not_to receive(:gets)
      subject.faux_prompt(prompt_marker)
    end
  end
end
