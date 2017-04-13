require_relative '../../lib/operations/main'

RSpec.describe Operation::Main do
  subject { Operation::Main.new }

  describe '#run' do
    before do
      allow(Configuration::Main).to receive(:initiale_state).and_return(state)
      allow(Game).to receive(:resolved?).and_return(false, false, true)
      allow(Game).to receive(:play)
      allow(Resolution).to receive(:wrap_up)
    end
    it 'gets state from Configuration' do
      expect(Configuration::Main).to receive(:initiale_state).once
      subject.run
    end
    it 'passes state to Game.play until Game.resolved?' do
      expect(Game).to receive(:play).with(state).twice
      subject.run
    end
    it 'passes state to Resolution.wrap_up after playing' do
      expect(Resolution).to receive(:wrap_up).with(state).once
      subject.run
    end
    let(:state) { junk }
  end
end
