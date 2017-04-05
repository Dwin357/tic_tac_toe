require_relative '../../../lib/players/players'
require_relative '../../../lib/interfaces/command_line_interface'

RSpec.describe Players do
  subject { Players.new }

  describe 'object creation' do
    it 'assigns empty players collection' do
      expect(subject.send(:players)).to eq []
    end
    it 'sets config step to 0' do
      expect(subject.send(:config_step)).to eq 0
    end
    it 'assigns empty error collection' do
      expect(subject.send(:errors)).to eq []
    end
  end

  describe 'configuration' do
    before { assign_var_with_val('config_step', step) }

    describe '#configured?' do
      context 'on step zero' do
        let(:step) { 0 }
        it 'false' do
          expect(subject.configured?).to be false
        end
      end
      context 'on step one' do
        let(:step) { 1 }
        it 'false' do
          expect(subject.configured?).to be false
        end
      end
      context 'on/after step 2' do
        let(:step) { 2 }
        it 'true' do
          expect(subject.configured?).to be true
        end
      end
    end

    describe '#next_configuration' do
      before do
        set_up_mock_for_interface
      end
      describe 'title blurb' do
        context 'on config_step 0' do
          let(:step) { 0 }
          it 'displays P1 msg' do
            msg = "\nPlayer One (ie first to act)\n----------------------------"
            expect(passed_interface).to receive(:display).with(msg)
            subject.next_configuration(passed_interface)
          end
        end
        context 'on config_step 1' do
          let(:step) { 1 }
          it 'displays P2 msg' do
            msg = "\nPlayer Two (ie second to act)\n-----------------------------"
            expect(passed_interface).to receive(:display).with(msg)
            subject.next_configuration(passed_interface)
          end
        end
      end
      describe 'user prompts' do
        let(:user_responses) { ['*', 'human'] }
        let(:resulting_arg) do
          { symbol: '*', type: :human, interface: passed_interface }
        end
        describe 'general' do
          it 'prmopts user twice' do
            expect(passed_interface).to receive(:prompt).with(' >')
            subject.next_configuration(passed_interface)
          end
          it 'passes prompted responses to #validate_player_arg?' do
            expect(subject).to receive(:validate_player_arg?).with(resulting_arg)
            subject.next_configuration(passed_interface)
          end
        end
        describe 'symbol atribute' do
          it 'displays attribute title' do
            msg = 'Select player symbol (must be unique)'
            expect(passed_interface).to receive(:display).with(msg)
            subject.next_configuration(passed_interface)
          end
          it 'displays attribute options' do
            msg = 'Options are: ! @ # $ % ^ & * + ='
            expect(passed_interface).to receive(:display).with(msg)
            subject.next_configuration(passed_interface)
          end
        end
        describe 'type atribute' do
          it 'displays attribute title' do
            msg = 'Select player type'
            expect(passed_interface).to receive(:display).with(msg)
            subject.next_configuration(passed_interface)
          end
          it 'displays attribute options' do
            msg = 'Options are: human hard easy medium'
            expect(passed_interface).to receive(:display).with(msg)
            subject.next_configuration(passed_interface)
          end
        end
      end
      describe 'input validation' do
        describe '#validate_player_arg?' do
          context 'with valid args' do
            let(:arg) { { symbol: '*', type: :human } }
            it 'true' do
              expect(subject.send(:validate_player_arg?, arg)).to be true
            end
            it 'does not populate errors' do
              subject.send(:validate_player_arg?, arg)
              expect(subject.send(:errors)).to eq []
            end
          end
          context 'with unrecognized type' do
            let(:arg) { { symbol: '*', type: :blah } }
            it 'false' do
              expect(subject.send(:validate_player_arg?, arg)).to be false
            end
            it 'populate new errors' do
              subject.send(:validate_player_arg?, arg)
              expect(subject.send(:errors)).to eq ['Invalid Type choice']
            end
            it 'clears old errors' do
              assign_var_with_val('errors', ['irrelevent error'])
              subject.send(:validate_player_arg?, arg)
              expect(subject.send(:errors)).not_to include 'irrelevent error'
            end
          end
          context 'with unrecognized symbol' do
            let(:arg) { { symbol: '.', type: :human } }
            it 'false' do
              expect(subject.send(:validate_player_arg?, arg)).to be false
            end
            it 'populate new errors' do
              subject.send(:validate_player_arg?, arg)
              expect(subject.send(:errors)).to eq ['Invalid Symbol choice']
            end
            it 'clears old errors' do
              assign_var_with_val('errors', ['irrelevent error'])
              subject.send(:validate_player_arg?, arg)
              expect(subject.send(:errors)).not_to include 'irrelevent error'
            end
          end
          context 'with already taken symbol' do
            before { subject.send(:add, arg) }
            let(:arg) { { symbol: '*', type: :human } }
            it 'false' do
              expect(subject.send(:validate_player_arg?, arg)).to be false
            end
            it 'populate new errors' do
              subject.send(:validate_player_arg?, arg)
              expect(subject.send(:errors)).to eq ['Invalid Symbol choice']
            end
            it 'clears old errors' do
              assign_var_with_val('errors', ['irrelevent error'])
              subject.send(:validate_player_arg?, arg)
              expect(subject.send(:errors)).not_to include 'irrelevent error'
            end
          end
        end
        context 'with valid input' do
          let(:user_responses) { ['*', 'easy'] }
          let(:resulting_arg) do
            { symbol: '*', type: :easy, interface: passed_interface }
          end
          describe '#add' do
            it 'adds player object to players collection' do
              expect { subject.next_configuration(passed_interface) }
                .to change { subject_var('players').count }.from(0).to(1)
              expect(subject_var('players').first).to be_kind_of ComputerPlayer
            end
            it 'creates a player obj matching args' do
              expect(AbstractPlayer).to receive(:build).with(resulting_arg)
              subject.next_configuration(passed_interface)
            end
          end
          it 'increments the config step' do
            expect { subject.next_configuration(passed_interface) }
              .to change { subject_var('config_step') }.from(0).to(1)
          end
          it 'does not display error message' do
            expect(subject).not_to receive(:display)
              .with("\nWhoops, that didn't work")
            subject.next_configuration(passed_interface)
          end
        end
        context 'with invalid input' do
          let(:user_responses) { ['*', 'invalid'] }
          it 'displays error title' do
            msg = "\nWhoops, that didn't work"
            expect(passed_interface).to receive(:display).with(msg)
            subject.next_configuration(passed_interface)
          end
          it 'displays error message' do
            msg = 'Invalid Type choice'
            expect(passed_interface).to receive(:display).with(msg)
            subject.next_configuration(passed_interface)
          end
          it 'does not increment config step' do
            expect { subject.next_configuration(passed_interface) }
              .not_to change { subject_var('config_step') }
          end
        end
      end

      # defaults variables and utility methods
      let(:step) { 0 }
      let(:user_responses) { [''] }
      let(:passed_interface) { CommandLineInterface.new }
      def set_up_mock_for_interface
        allow(passed_interface).to receive(:display)
        allow(passed_interface).to receive(:prompt).and_return(*user_responses)
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
