require_relative '../../../lib/operations/configuration/main'

RSpec.describe Configuration::Main do
  describe '.initiale_state' do
    subject { Configuration::Main.initiale_state }

    it 'returns a ConfiguredState object' do
      stub_configured_players
      expect(subject).to be_a Configuration::ConfiguredState
    end
    describe 'configured state details' do
      before { stub_configured_players }
      describe 'count' do
        it 'set to 0' do
          expect(subject.count).to eq 0
        end
      end
      describe 'interface' do
        it 'command line interface' do
          expect(subject.interface).to be_a CommandLineInterface
        end
      end
      describe 'board' do
        it 'board object' do
          expect(subject.board).to be_a Board
        end
        it 'edge of 3' do
          expect(subject.board.edge).to eq 3
        end
        it 'is empty' do
          expect(subject.board).to be_empty
        end
      end
      describe 'players' do
        it 'players object' do
          expect(subject.players).to be_a Players
        end
      end
      describe 'errors' do
        it 'set as []' do
          expect(subject.errors).to eq []
        end
      end
    end
  end

  describe '.test_state' do
    context 'with no passed config' do
      before { stub_configured_players }
      subject { Configuration::Main.test_state }
      describe 'count' do
        it 'set to 0' do
          expect(subject.count).to eq 0
        end
      end
      describe 'interface' do
        it 'command line interface' do
          expect(subject.interface).to be_a CommandLineInterface
        end
      end
      describe 'board' do
        it 'board object' do
          expect(subject.board).to be_a Board
        end
        it 'edge of 3' do
          expect(subject.board.edge).to eq 3
        end
        it 'is empty' do
          expect(subject.board).to be_empty
        end
      end
      describe 'players' do
        it 'players object' do
          expect(subject.players).to be_a Players
        end
      end
      describe 'errors' do
        it 'set as []' do
          expect(subject.errors).to eq []
        end
      end
    end
    context 'with passed run_config' do
      subject { Configuration::Main.test_state(run_config) }
      before { stub_configured_players }
      context 'count' do
        let(:run_config) { { count: passed_value } }
        it 'can be overwritten' do
          expect(subject.count).to eq passed_value
        end
      end
      context 'interface' do
        let(:run_config) { { interface: passed_value } }
        it 'can be overwritten' do
          expect(subject.interface).to eq passed_value
        end
      end
      context 'board' do
        let(:run_config) { { board: passed_value } }
        it 'can be overwritten' do
          expect(subject.board).to eq passed_value
        end
      end
      context 'players' do
        let(:run_config) { { players: passed_value } }
        it 'can be overwritten' do
          expect(subject.players).to eq passed_value
        end
      end
      context 'errors' do
        let(:run_config) { { errors: passed_value } }
        it 'can be overwritten' do
          expect(subject.errors).to eq passed_value
        end
      end
      let(:passed_value) { junk }
    end
    context 'with players passed as false' do
      subject { Configuration::Main.test_state(run_config) }
      before { stub_configured_players }
      context 'replicate protostate' do
        let(:run_config) { { players: false } }
        it 'players set at nil' do
          expect(subject.players).to be_nil
        end
      end
    end
  end
  def stub_configured_players
    allow_any_instance_of(Players::Configuration::Main)
      .to receive(:configured_players).and_return(Players.new)
  end
end
