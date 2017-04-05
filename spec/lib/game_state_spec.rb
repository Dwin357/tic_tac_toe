require_relative '../../lib/game_state'
require_relative '../../lib/interfaces/command_line_interface'

RSpec.describe GameState do
  subject { GameState.new(interface: passed_interface) }

  before do
    allow(passed_interface).to receive(:prompt).and_return('')
    allow(passed_interface).to receive(:display)
  end

  describe 'object creation' do
    it 'assigns a Players object' do
      expect(subject.send(:players)).to be_an_instance_of Players
    end
    it 'assigns a Board object' do
      expect(subject.send(:board)).to be_an_instance_of Board
    end
    it 'assigns count to 0' do
      expect(subject.send(:count)).to eq 0
    end
    it 'assigns config_step to 0' do
      expect(subject.send(:config_step)).to eq 0
    end
    it 'assigns tear_down_step to 0' do
      expect(subject.send(:tear_down_step)).to eq 0
    end
    it 'assigns interface to passed object' do
      expect(subject.send(:interface)).to eq passed_interface
    end
    it 'assigns an empty errors collection' do
      expect(subject.send(:errors)).to eq []
    end
  end

  describe 'configuration' do
    before { assign_var_to_val('config_step', step) }

    describe '#configured?' do
      context 'on/after step one' do
        let(:step) { 1 }
        it 'true' do
          expect(subject.configured?).to be true
        end
      end
      context 'on step zero' do
        let(:step) { 0 }
        it 'false' do
          expect(subject.configured?).to be false
        end
      end
    end
    describe '#next_configuration' do
      before do
        assign_var_to_val('players', players)
        allow(players).to receive(:configured?).and_return(true)
      end
      describe 'step 0' do
        let(:step) { 0 }
        it 'increments the config_step' do
          expect { subject.next_configuration }
            .to change { subject.send(:config_step) }.from(0).to(1)
        end
        describe '#configure_players' do
          before do
            allow(players).to receive(:configured?).and_return(false, false, true)
          end
          it 'calls #next_configuration on players until #configured? is true' do
            expect(players).to receive(:next_configuration).twice
            subject.send(:configure_players)
          end
        end
      end
      let(:players) { Players.new }
    end
  end

  describe 'tear down' do
    before do
      assign_var_to_val('count', count)
      assign_var_to_val('players', players)
      assign_var_to_val('board', board)
      assign_var_to_val('tear_down_step', step)
    end

    describe '#torn_down?' do
      context 'on/after step one' do
        let(:step) { 1 }
        it 'true' do
          expect(subject.torn_down?).to be true
        end
      end
      context 'on step zero' do
        let(:step) { 0 }
        it 'false' do
          expect(subject.torn_down?).to be false
        end
      end
    end
    describe '#next_tear_down' do
      describe 'step 0' do
        let(:step) { 0 }
        it 'increments the tear_down_step' do
          expect { subject.next_tear_down }
            .to change { subject.send(:tear_down_step) }.from(0).to(1)
        end
        context 'when game is won' do
          let(:board) do
            transform_board(%w(X 1 2
                               O X 5
                               6 O X))
          end
          it 'displays the board' do
            expect(passed_interface).to receive(:display)
              .with(board_display_for(board.display))
            subject.next_tear_down
          end
          it 'displays win exit msg' do
            msg = "Game over\nCongratulations!!! #{last_acting_player.symbol}\n"
            expect(passed_interface).to receive(:display).with(msg)
            subject.next_tear_down
          end
        end
        context 'when game is draw' do
          let(:board) do
            transform_board(%w(O X O
                               X O X
                               X O X))
          end
          it 'displays the board' do
            expect(passed_interface).to receive(:display)
              .with(board_display_for(board.display))
            subject.next_tear_down
          end
          it 'displays draw msg' do
            msg = "Game over\nGood game, better luck next time\n"
            expect(passed_interface).to receive(:display).with(msg)
            subject.next_tear_down
          end
        end
        let(:last_acting_player) { players.active_player(count - 1) }
      end
    end

    let(:players) { default_players }
    let(:board) { default_board }
    let(:count) { 5 }
  end

  describe 'game turn' do
    before do
      assign_var_to_val('count', count)
      assign_var_to_val('players', players)
      assign_var_to_val('board', board)
    end

    describe '#game_over?' do
      context 'when the board thinks the game is over' do
        before { allow(board).to receive(:game_over?).and_return(true) }
        it 'returns true' do
          expect(subject.game_over?).to be true
        end
      end
      context 'when the board doesnt think the game is over' do
        before { allow(board).to receive(:game_over?).and_return(false) }
        it 'returns false' do
          expect(subject.game_over?).to be false
        end
      end
    end
    describe 'oscilating turns' do
      before do
        allow(player_one).to receive(:get_spot).and_return(p1_mv)
        allow(player_two).to receive(:get_spot).and_return(p2_mv)
      end

      context 'when count is 0/even' do
        let(:count) { 0 }
        it 'player 1 is prompted for move' do
          expect(player_one).to receive(:get_spot).once
          subject.resolve_turn
        end
        it 'player 1s symbol is given to the board for selection' do
          expect(board).to receive(:select).with(p1_mv, player_one.symbol).once
          subject.resolve_turn
        end
      end
      context 'when count is odd' do
        let(:count) { 1 }
        it 'player 2 is prompted for move' do
          expect(player_two).to receive(:get_spot).once
          subject.resolve_turn
        end
        it 'player 2s symbol is given to the board for selection' do
          expect(board).to receive(:select).with(p2_mv, player_two.symbol).once
          subject.resolve_turn
        end
      end
    end
    describe 'data validation' do
      before { allow(player_one).to receive(:get_spot).and_return(move) }

      let(:board) { transform_board(%w(0 1 2 3 X 5 O 7 8)) }

      describe '#set_up_move' do
        it 'displays board' do
          expect(passed_interface).to receive(:display)
            .with(board_display_for(display_board))
          subject.resolve_turn
        end
        it 'displays move title' do
          expect(passed_interface).to receive(:display)
            .with('Select your move')
          subject.resolve_turn
        end
        it 'displays options' do
          msg = "Options are #{transform_board(display_board).avaliable_spaces}"
          expect(passed_interface).to receive(:display).with(msg)
          subject.resolve_turn
        end
        context 'with errors' do
          before { assign_var_to_val('errors', [error]) }
          it 'displays the error' do
            expect(passed_interface).to receive(:display).with(error)
            subject.resolve_turn
          end
          let(:error) { 'horrible error' }
        end
        context 'without erros' do
          before { assign_var_to_val('errors', []) }
          it 'doesnt show an error' do
            expect(passed_interface).not_to receive(:display).with(error)
            subject.resolve_turn
          end
          let(:error) { 'horrible error' }
        end
        let(:display_board) { %w(0 1 2 3 X 5 O 7 8) }
        let(:move) { rand(9) }
      end
      describe '#valid_move?' do
        context 'when move is taken by self' do
          let(:move) { 6 }
          it 'returns false' do
            expect(subject.send(:valid_move?, move, board)).to be false
          end
          it 'populates an error' do
            expect { subject.send(:valid_move?, move, board) }
              .to change { subject.send(:errors) }.from([])
              .to(['Sorry, that move wasnt an option'])
          end
        end
        context 'when move is taken by other' do
          let(:move) { 4 }
          it 'returns false' do
            expect(subject.send(:valid_move?, move, board)).to be false
          end
          it 'populates an error' do
            expect { subject.send(:valid_move?, move, board) }
              .to change { subject.send(:errors) }.from([])
              .to(['Sorry, that move wasnt an option'])
          end
        end
        context 'when move is out of bounds' do
          let(:move) { 10 }
          it 'returns false' do
            expect(subject.send(:valid_move?, move, board)).to be false
          end
          it 'populates an error' do
            expect { subject.send(:valid_move?, move, board) }
              .to change { subject.send(:errors) }.from([])
              .to(['Sorry, that move wasnt an option'])
          end
        end
        context 'when move is valid' do
          let(:move) { 1 }
          it 'returns true' do
            expect(subject.send(:valid_move?, move, board)).to be true
          end
          it 'populates an error' do
            expect { subject.send(:valid_move?, move, board) }
              .not_to change { subject.send(:errors) }
          end
        end
        context 'when there is an old error' do
          before { assign_var_to_val('errors', [old_error]) }
          let(:move) { 1 }
          it 'clears old errors' do
            expect { subject.send(:valid_move?, move, board) }
              .to change { subject.send(:errors) }.from([old_error]).to([])
          end
          let(:old_error) { SecureRandom.uuid }
        end
      end
      describe 'when move is valid' do
        let(:move) { 1 }
        let(:count) { 0 } # player 1 acting
        it 'increments the count' do
          expect { subject.resolve_turn }.to change { subject.send(:count) }
            .from(0).to(1)
        end
        it 'selects players move on board' do
          expect(board).to receive(:select).with(move, player_one.symbol).once
          subject.resolve_turn
        end
      end
      describe 'whem move is invalid' do
        let(:move) { 4 }
        let(:count) { 0 } # player 1 acting
        it 'does not increment the count (ie stays on current players turn)' do
          expect { subject.resolve_turn }.not_to change { subject.send(:count) }
        end
      end
    end

    let(:count) { 0 }
    let(:board) { default_board }
    let(:p1_mv) { rand(9) }
    let(:p2_mv) { rand(9) }
    let(:players) { default_players }
    let(:player_one) { players.active_player(0) }
    let(:player_two) { players.active_player(1) }
  end

  let(:default_board) { Board.new }
  let(:default_players) do
    Players.new.tap do |players|
      players.add(symbol: p1_sym, type: :human)
      players.add(symbol: p2_sym, type: :easy)
    end
  end
  let(:p1_sym) { 'O' }
  let(:p2_sym) { 'X' }
  let(:passed_interface) { CommandLineInterface.new }
  def transform_board(display_board)
    board_object = Board.new
    display_board.each_with_index do |el, i|
      next if i.to_s == el
      board_object.select(i, el)
    end
    board_object
  end

  def board_display_for(board_input)
    board = transform_board(board_input).display
    show  = "\n "
    show += "#{board[0]} | #{board[1]} | #{board[2]}"
    show += " \n===+===+===\n "
    show += "#{board[3]} | #{board[4]} | #{board[5]}"
    show += " \n===+===+===\n "
    show += "#{board[6]} | #{board[7]} | #{board[8]}"
    show +  " \n"
  end

  def assign_var_to_val(var, val)
    subject.instance_variable_set("@#{var}".to_sym, val)
  end
end
