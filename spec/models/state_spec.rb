require_relative '../../lib/models/state'

class TestState < State
  def enforce_private_constructor; end
end

RSpec.describe State do
  describe 'private constructor' do
    context 'when enforcer is not overwritten' do
      subject { State.new }
      it 'raises a PrivateConstructor error on initialize' do
        expect { subject }.to raise_error State::PrivateConstructor
      end
    end
    context 'when enforcer is overwritten' do
      subject { TestState.new }
      it 'does not raises a PrivateConstructor error on initialize' do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe 'object creation' do
    subject { TestState.new }
    it 'interface attribtue avaliable & empty' do
      expect(subject.interface).to be_nil
    end
    it 'board attribtue avaliable & empty' do
      expect(subject.board).to be_nil
    end
    it 'players attribtue avaliable & empty' do
      expect(subject.players).to be_nil
    end
    it 'count attribtue avaliable & empty' do
      expect(subject.count).to be_nil
    end
    it 'errors attribtue avaliable & empty' do
      expect(subject.errors).to be_nil
    end
  end
end
