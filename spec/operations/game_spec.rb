require_relative '../../lib/operations/game'
require_relative '../../lib/operations/configuration/main'

RSpec.describe Game do
  describe '.resolved?' do
    context 'when board is full' do
      let(:board_state) do
        ['X', '@', 'X',
         '@', '@', 'X',
         '@', 'X', '@']
      end
      it 'true' do
        expect(Game.resolved?(state)).to be true
      end
    end
    context 'when board is not full(no winner)' do
      let(:board_state) do
        ['X', '@', 'X',
         '@', nil, 'X',
         '@', 'X', '@']
      end
      it 'false' do
        expect(Game.resolved?(state)).to be false
      end
    end
    context 'when a player has won' do
      context 'vertical win' do
        context 'col 1' do
          let(:board_state) do
            ['@', '@', 'X',
             '@', nil, 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.resolved?(state)).to be true
          end
        end
        context 'col 2' do
          let(:board_state) do
            ['X', 'X', '@',
             nil, 'X', 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.resolved?(state)).to be true
          end
        end
        context 'col 3' do
          let(:board_state) do
            ['X', '@', 'X',
             '@', nil, 'X',
             '@', 'X', 'X']
          end
          it 'true' do
            expect(Game.resolved?(state)).to be true
          end
        end
      end
      context 'horizontil win' do
        context 'row 1' do
          let(:board_state) do
            ['@', '@', '@',
             'X', nil, 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.resolved?(state)).to be true
          end
        end
        context 'row 2' do
          let(:board_state) do
            ['X', nil, '@',
             'X', 'X', 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.resolved?(state)).to be true
          end
        end
        context 'row 3' do
          let(:board_state) do
            ['X', '@', '@',
             '@', nil, 'X',
             'X', 'X', 'X']
          end
          it 'true' do
            expect(Game.resolved?(state)).to be true
          end
        end
      end
      context 'diagonal win' do
        context 'ascending' do
          let(:board_state) do
            ['X', nil, '@',
             'X', '@', 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.resolved?(state)).to be true
          end
        end
        context 'descending' do
          let(:board_state) do
            ['X', '@', '@',
             '@', 'X', 'X',
             'X', nil, 'X']
          end
          it 'true' do
            expect(Game.resolved?(state)).to be true
          end
        end
      end
    end
    let(:run_config) { { players: unconfigured_players, board: board } }
  end
  describe '.play' do
    before do
      allow_any_instance_of(Game::Cell).to receive(:turn_view).and_return(cell_view)
      allow(interface).to receive(:display)
      allow(interface).to receive(:faux_prompt)
      allow(p1).to receive(:get_spot).and_return(mv)
    end
    context 'player provides valid move' do
      let(:mv) { 4 }
      it 'displays turn view' do
        expect(interface).to receive(:display).with(cell_view).once
        Game.play(state)
      end
      it 'increments the count' do
        expect { Game.play(state) }.to change { state.count }.from(0).to(1)
      end
      it 'selects the move' do
        expect(board).to receive(:select).with(mv, p1.symbol)
        Game.play(state)
      end
      it 'does not set any errors' do
        expect { Game.play(state) }.not_to change { state.errors }
      end
    end
    context 'player provides invalid move' do
      let(:mv) { 1 }
      it 'displays turn view' do
        expect(interface).to receive(:display).with(cell_view).once
        Game.play(state)
      end
      it 'does not increment the count' do
        expect { Game.play(state) }.not_to change { state.count }
      end
      it 'does not select a move' do
        expect(board).not_to receive(:select)
        Game.play(state)
      end
      it 'sets an error' do
        expect { Game.play(state) }.to change { state.errors }
          .from([]).to(['Sorry, that move wasnt an option'])
      end
    end
    let(:board_state) do
      ['X', '@', '@',
       '@', nil, 'X',
       'X', 'X', 'X']
    end
    let(:run_config) do
      { players: players, board: board, interface: interface }
    end
    let(:p1) { players.active_player(0) }
    let(:players) do
      Players.new.tap do |players|
        players.add(symbol: '@', type: :hard)
        players.add(symbol: '*', type: :easy)
      end
    end
    let(:cell_view) { junk }
  end
  describe '.over?' do
    context 'when board is full' do
      let(:board_state) do
        ['X', '@', 'X',
         '@', '@', 'X',
         '@', 'X', '@']
      end
      it 'true' do
        expect(Game.over?(board)).to be true
      end
    end
    context 'when board is not full(no winner)' do
      let(:board_state) do
        ['X', '@', 'X',
         '@', nil, 'X',
         '@', 'X', '@']
      end
      it 'false' do
        expect(Game.over?(board)).to be false
      end
    end
    context 'when a player has won' do
      context 'vertical win' do
        context 'col 1' do
          let(:board_state) do
            ['@', '@', 'X',
             '@', nil, 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.over?(board)).to be true
          end
        end
        context 'col 2' do
          let(:board_state) do
            ['X', 'X', '@',
             nil, 'X', 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.over?(board)).to be true
          end
        end
        context 'col 3' do
          let(:board_state) do
            ['X', '@', 'X',
             '@', nil, 'X',
             '@', 'X', 'X']
          end
          it 'true' do
            expect(Game.over?(board)).to be true
          end
        end
      end
      context 'horizontil win' do
        context 'row 1' do
          let(:board_state) do
            ['@', '@', '@',
             'X', nil, 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.over?(board)).to be true
          end
        end
        context 'row 2' do
          let(:board_state) do
            ['X', nil, '@',
             'X', 'X', 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.over?(board)).to be true
          end
        end
        context 'row 3' do
          let(:board_state) do
            ['X', '@', '@',
             '@', nil, 'X',
             'X', 'X', 'X']
          end
          it 'true' do
            expect(Game.over?(board)).to be true
          end
        end
      end
      context 'diagonal win' do
        context 'ascending' do
          let(:board_state) do
            ['X', nil, '@',
             'X', '@', 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.over?(board)).to be true
          end
        end
        context 'descending' do
          let(:board_state) do
            ['X', '@', '@',
             '@', 'X', 'X',
             'X', nil, 'X']
          end
          it 'true' do
            expect(Game.over?(board)).to be true
          end
        end
      end
    end
  end
  describe '.won?' do
    context 'when board is full (no winner)' do
      let(:board_state) do
        ['X', '@', 'X',
         '@', '@', 'X',
         '@', 'X', '@']
      end
      it 'false' do
        expect(Game.won?(board)).to be false
      end
    end
    context 'when board is not full(no winner)' do
      let(:board_state) do
        ['X', '@', 'X',
         '@', nil, 'X',
         '@', 'X', '@']
      end
      it 'false' do
        expect(Game.won?(board)).to be false
      end
    end
    context 'when a player has won' do
      context 'vertical win' do
        context 'col 1' do
          let(:board_state) do
            ['@', '@', 'X',
             '@', nil, 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.won?(board)).to be true
          end
        end
        context 'col 2' do
          let(:board_state) do
            ['X', 'X', '@',
             nil, 'X', 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.won?(board)).to be true
          end
        end
        context 'col 3' do
          let(:board_state) do
            ['X', '@', 'X',
             '@', nil, 'X',
             '@', 'X', 'X']
          end
          it 'true' do
            expect(Game.won?(board)).to be true
          end
        end
      end
      context 'horizontil win' do
        context 'row 1' do
          let(:board_state) do
            ['@', '@', '@',
             'X', nil, 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.won?(board)).to be true
          end
        end
        context 'row 2' do
          let(:board_state) do
            ['X', nil, '@',
             'X', 'X', 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.won?(board)).to be true
          end
        end
        context 'row 3' do
          let(:board_state) do
            ['X', '@', '@',
             '@', nil, 'X',
             'X', 'X', 'X']
          end
          it 'true' do
            expect(Game.won?(board)).to be true
          end
        end
      end
      context 'diagonal win' do
        context 'ascending' do
          let(:board_state) do
            ['X', nil, '@',
             'X', '@', 'X',
             '@', 'X', '@']
          end
          it 'true' do
            expect(Game.won?(board)).to be true
          end
        end
        context 'descending' do
          let(:board_state) do
            ['X', '@', '@',
             '@', 'X', 'X',
             'X', nil, 'X']
          end
          it 'true' do
            expect(Game.won?(board)).to be true
          end
        end
      end
    end
  end
  let(:interface) { CommandLineInterface.new }
  let(:state) { Configuration::Main.test_state(run_config) }
  let(:unconfigured_players) { Players.new }
  let(:board) do
    Board.new(edge: 3).tap do |brd|
      Board.assign_board_state(brd, board_state)
    end
  end
end
