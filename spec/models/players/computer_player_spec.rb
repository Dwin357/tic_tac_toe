require_relative '../../../lib/models/players/abstract_player'
require_relative '../../../lib/interfaces/command_line_interface'

RSpec.describe ComputerPlayer do
  describe 'shared behavior' do
    subject { AbstractPlayer.build(hard_arg) }

    before do
      allow(subject).to receive(:real_move).and_return(mv)
      stub_interface
    end

    describe '#get_spot' do
      it 'calls #real_move' do
        expect(subject).to receive(:real_move).with(board, players).once
        subject.get_spot(board, players)
      end
      it 'calls #user_experience with #real_move rtn' do
        expect(subject).to receive(:user_experience).with(mv).once
        subject.get_spot(board, players)
      end
      it 'rtns the response of #real_move' do
        expect(subject.get_spot(board, players)).to eq mv
      end
    end
    describe '#user_experience' do
      it 'displays a prompt' do
        expect(interface).to receive(:faux_prompt).once
        subject.user_experience(mv)
      end
      it 'displays move' do
        expect(interface).to receive(:display).with(mv.to_s).once
        subject.user_experience(mv)
      end
    end

    let(:mv)      { rand(9) }
    let(:board)   { junk }
    let(:players) { junk }
  end

  describe 'player implementations' do
    context 'hard player' do
      subject { AbstractPlayer.build(hard_arg) }
      it 'implements hard mode logic' do
        expect(subject.send(:module_id)).to eq HardMode
      end
    end
    context 'medium player' do
      subject { AbstractPlayer.build(medium_arg) }
      it 'implements medium mode logic' do
        expect(subject.send(:module_id)).to eq MediumMode
      end
    end
    context 'easy player' do
      subject { AbstractPlayer.build(easy_arg) }
      it 'implements easy mode logic' do
        expect(subject.send(:module_id)).to eq EasyMode
      end
    end
  end

  let(:hard_arg) {   { symbol: sym, interface: interface, type: :hard } }
  let(:medium_arg) { { symbol: sym, interface: interface, type: :medium } }
  let(:easy_arg) {   { symbol: sym, interface: interface, type: :easy } }

  let(:sym) { '@' }
  let(:interface) { CommandLineInterface.new }

  def stub_interface
    allow(interface).to receive(:display)
    allow(interface).to receive(:faux_prompt)
  end
end
