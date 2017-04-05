require_relative '../../../lib/players/abstract_player'

RSpec.describe AbstractPlayer do
  describe 'object creation' do
    subject { AbstractPlayer.new(human_arg) }
    it 'assigns public symbol' do
      expect(subject.symbol).to eq human_arg[:symbol]
    end
    it 'assigns private interface' do
      expect(subject.send(:interface)).to eq human_arg[:interface]
    end
  end

  describe '.build' do
    context 'human arg' do
      it 'human player' do
        expect(AbstractPlayer.build(human_arg)).to be_a HumanPlayer
      end
    end
    context 'hard arg' do
      it 'hard player' do
        expect(AbstractPlayer.build(hard_arg)).to be_a HardPlayer
      end
    end
    context 'medium arg' do
      it 'medium player' do
        expect(AbstractPlayer.build(medium_arg)).to be_a MediumPlayer
      end
    end
    context 'easy arg' do
      it 'easy player' do
        expect(AbstractPlayer.build(easy_arg)).to be_a EasyPlayer
      end
    end
  end

  let(:human_arg) { { symbol: '@', interface: interface, type: :human } }
  let(:hard_arg) { { symbol: '@', interface: interface, type: :hard } }
  let(:medium_arg) { { symbol: '@', interface: interface, type: :medium } }
  let(:easy_arg) { { symbol: '@', interface: interface, type: :easy } }

  let(:interface) { SecureRandom.uuid }
end
