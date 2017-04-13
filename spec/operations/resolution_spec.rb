require_relative '../../lib/operations/resolution'
require_relative '../../lib/operations/configuration/main'

RSpec.describe Resolution do
  describe '.wrap_up' do
    before do
      allow_any_instance_of(Resolution::Cell).to receive(:win_msg).and_return(win_msg)
      allow_any_instance_of(Resolution::Cell).to receive(:draw_msg).and_return(draw_msg)
    end
    context 'game is won' do
      let(:board_state) do
        ['X', '@', '@',
         '@', nil, 'X',
         'X', 'X', 'X']
      end
      it 'displays cells win msg' do
        expect(interface).to receive(:display).with(win_msg).once
        Resolution.wrap_up(state)
      end
    end
    context 'game is draw' do
      let(:board_state) do
        ['X', '@', 'X',
         '@', '@', 'X',
         '@', 'X', '@']
      end
      it 'displays cells draw msg' do
        expect(interface).to receive(:display).with(draw_msg).once
        Resolution.wrap_up(state)
      end
    end
    let(:draw_msg) { 'aww' }
    let(:win_msg) { 'yaa' }
    let(:run_config) do
      { interface: interface, board: board, players: unconfigured_players }
    end
  end
  describe 'inherieted method' do
    describe '.won?' do
      context 'when board is full (no winner)' do
        let(:board_state) do
          ['X', '@', 'X',
           '@', '@', 'X',
           '@', 'X', '@']
        end
        it 'false' do
          expect(Resolution.won?(board)).to be false
        end
      end
      context 'when board is not full(no winner)' do
        let(:board_state) do
          ['X', '@', 'X',
           '@', nil, 'X',
           '@', 'X', '@']
        end
        it 'false' do
          expect(Resolution.won?(board)).to be false
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
              expect(Resolution.won?(board)).to be true
            end
          end
          context 'col 2' do
            let(:board_state) do
              ['X', 'X', '@',
               nil, 'X', 'X',
               '@', 'X', '@']
            end
            it 'true' do
              expect(Resolution.won?(board)).to be true
            end
          end
          context 'col 3' do
            let(:board_state) do
              ['X', '@', 'X',
               '@', nil, 'X',
               '@', 'X', 'X']
            end
            it 'true' do
              expect(Resolution.won?(board)).to be true
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
              expect(Resolution.won?(board)).to be true
            end
          end
          context 'row 2' do
            let(:board_state) do
              ['X', nil, '@',
               'X', 'X', 'X',
               '@', 'X', '@']
            end
            it 'true' do
              expect(Resolution.won?(board)).to be true
            end
          end
          context 'row 3' do
            let(:board_state) do
              ['X', '@', '@',
               '@', nil, 'X',
               'X', 'X', 'X']
            end
            it 'true' do
              expect(Resolution.won?(board)).to be true
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
              expect(Resolution.won?(board)).to be true
            end
          end
          context 'descending' do
            let(:board_state) do
              ['X', '@', '@',
               '@', 'X', 'X',
               'X', nil, 'X']
            end
            it 'true' do
              expect(Resolution.won?(board)).to be true
            end
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
