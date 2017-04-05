require_relative '../../../lib/players/abstract_player'
require_relative '../../../lib/interfaces/command_line_interface'

RSpec.describe HumanPlayer do
  subject { AbstractPlayer.build(human_arg) }

  before { allow(interface).to receive(:prompt).and_return(mv) }

  describe '#get_spot' do
    it 'displays a prompt' do
      expect(interface).to receive(:prompt).once
      subject.get_spot(junk, junk)
    end
    it 'rtns the move' do
      expect(subject.get_spot(junk, junk)).to eq mv
    end
    let(:mv) { rand(9) }
  end

  let(:human_arg) { { symbol: sym, interface: interface, type: :human } }
  let(:interface) { CommandLineInterface.new }
  let(:sym) { '@' }

  def junk
    SecureRandom.uuid
  end
end
