require_relative '../../../lib/models/players/players'
require_relative '../../../lib/interfaces/command_line_interface'

RSpec.describe Players do
  subject { Players.new }

  describe 'object creation' do
    it 'assigns empty players collection' do
      expect(subject.send(:players)).to eq []
    end
  end

  describe '#add' do
    before do
      allow(AbstractPlayer).to receive(:build).and_return(player)
    end
    it 'AbstractPlayer builds the player' do
      expect(AbstractPlayer).to receive(:build).with(arg).once
      subject.add(arg)
    end
    it 'puts player into player collection' do
      expect { subject.add(arg) }.to change { subject.send(:players) }
        .from([]).to([player])
    end
    let(:arg) { junk }
    let(:player) { junk }
  end

  describe '#available_symbols' do
    context 'no current players' do
      it 'returns full collection ie [! @ # $ % ^ & * + =]' do
        expect(subject.available_symbols).to eq %w(! @ # $ % ^ & * + =)
      end
    end
    context 'one player' do
      before { subject.add(symbol: '$', type: :human) }
      it 'returns collection minus players symbol ie [! @ # % ^ & * + =]' do
        expect(subject.available_symbols).to eq %w(! @ # % ^ & * + =)
      end
    end
  end

  context 'with two players' do
    before { assign_players }

    describe '#active_player' do
      context 'when count is zero or even' do
        it 'returns player 1' do
          expect(subject.active_player(0)).to eq p1
          expect(subject.active_player(2)).to eq p1
        end
      end
      context 'when count is odd' do
        it 'returns player 2' do
          expect(subject.active_player(1)).to eq p2
        end
      end
    end

    describe '#other_players_symbol' do
      context 'when passed p1 symbol' do
        it "returns p2's symbol" do
          expect(subject.other_players_symbol(p1.symbol)).to eq p2.symbol
        end
      end
      context 'when passed p2 symbol' do
        it "returns p1's symbol" do
          expect(subject.other_players_symbol(p2.symbol)).to eq p1.symbol
        end
      end
    end

    def assign_players
      assign_var_with_val('players', [p1, p2])
    end
    let(:p1) { AbstractPlayer.build(symbol: 'O', type: :human) }
    let(:p2) { AbstractPlayer.build(symbol: 'X', type: :easy) }
  end

  def subject_var(var)
    subject.instance_variable_get("@#{var}".to_sym)
  end

  def assign_var_with_val(var, val)
    subject.instance_variable_set("@#{var}".to_sym, val)
  end
end
