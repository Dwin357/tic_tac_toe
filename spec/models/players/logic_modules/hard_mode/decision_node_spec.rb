require_relative '../../../../../lib/models/players/logic_modules/hard_mode/decision_node'
require_relative '../../../../../lib/models/players/logic_modules/hard_mode/game_moment'
require_relative '../../../../../lib/models/players/players'
require_relative '../../../../../lib/models/board'

RSpec.describe HardMode::DecisionNode do
  subject { HardMode::DecisionNode.new(default_moment) }

  describe 'object creation' do
    it 'move assigned and readable' do
      expect(subject.move).to eq move
    end
    it 'assigns actor' do
      expect(subject.actor).to eq call_sym
    end
    it 'generates a move score' do
      expect(subject.move_score).not_to be_nil
    end
    it 'generates posibilities' do
      expect(subject.posibilities).not_to be_nil
    end
    describe 'build_posibilities' do
      context 'for a board which is drawn/full' do
        let(:board_state) do
          ['X', '@', 'X',
           '@', 'X', '@',
           '@', 'X', '@']
        end
        let(:move) { rand(9) }
        it 'is empty' do
          expect(subject.posibilities).to eq []
        end
      end
      context 'for a board which has resolved (a winner)' do
        let(:board_state) do
          ['X', 'X', 'X',
           nil, nil, '@',
           '@', nil, '@']
        end
        let(:move) { rand(3) }
        it 'is empty' do
          expect(subject.posibilities).to eq []
        end
      end
      context 'for a board which has not resolved' do
        let(:board_state) do
          ['X', '@', 'X',
           '@', nil, nil,
           nil, 'X', '@']
        end
        let(:move) { [0, 1, 7].sample }
        it 'has entries for each open space' do
          expect(subject.posibilities.count).to eq 3
        end
      end
    end
    describe 'build_move_score' do
      context 'when board has resolved (ie self is a game ending move)' do
        context 'actor won' do
          let(:board_state) do
            ['X', '@', 'X',
             nil, 'X', '@',
             '@', 'X', 'X']
          end
          it 'returns win score' do
            expect(subject.move_score).to eq win_score
          end
        end
        context 'actor drew' do
          let(:board_state) do
            ['X', '@', 'X',
             '@', 'X', '@',
             '@', 'X', '@']
          end
          it 'returns draw score' do
            expect(subject.move_score).to eq draw_score
          end
        end
      end
      context 'scenario: my move sets up' do
        context 'immediate loss' do
          let(:board_state) do
            ['@', 'X', 'X',
             nil, '@', '@',
             '@', nil, 'X']
          end
          it 'scores loss' do
            expect(subject.move_score).to eq lose_score
          end
        end
        context 'immediate draw' do
          let(:board_state) do
            ['@', 'X', 'X',
             'X', '@', '@',
             '@', nil, 'X']
          end
          it 'scores draw' do
            expect(subject.move_score).to eq draw_score
          end
        end
        describe 'ambigious' do
          context 'win+lose+draw' do
            let(:board_state) do
              ['@', 'X', '@',
               'X', 'X', '@',
               nil, nil, nil]
            end
            it 'returns win score' do
              expect(subject.move_score).to eq lose_score
            end
          end
          context 'win+win' do
            let(:board_state) do
              [nil, nil, '@',
               'X', nil, '@',
               'X', nil, 'X']
            end
            it 'returns win score' do
              expect(subject.move_score).to eq win_score
            end
          end
          context 'lose+lose' do
            let(:board_state) do
              [nil, nil, 'X',
               '@', nil, 'X',
               '@', nil, '@']
            end
            it 'returns win score' do
              expect(subject.move_score).to eq lose_score
            end
          end
          context 'draw+draw' do
            let(:board_state) do
              ['@', nil, 'X',
               'X', 'X', '@',
               '@', nil, 'X']
            end
            it 'returns draw score' do
              expect(subject.move_score).to eq draw_score
            end
          end
          context 'win+draw' do
            let(:board_state) do
              ['X', '@', 'X',
               '@', 'X', 'X',
               '@', nil, nil]
            end
            it 'returns draw score' do
              expect(subject.move_score).to eq draw_score
            end
          end
          context 'draw+lose' do
            let(:board_state) do
              ['@', 'X', '@',
               'X', '@', '@',
               'X', nil, nil]
            end
            it 'returns lose score' do
              expect(subject.move_score).to eq lose_score
            end
          end
          context 'win+lose' do
            let(:board_state) do
              [nil, 'X', '@',
               'X', '@', '@',
               'X', nil, nil]
            end
            it 'returns lose score' do
              expect(subject.move_score).to eq lose_score
            end
          end
        end
      end
    end
    let(:board_state) do
      ['X', '@', 'X',
       nil, 'X', '@',
       '@', nil, '@']
    end
    let(:move) { [1, 3, 4, 7, 8].sample }
  end
  let(:default_moment) do
    symbol = call_sym
    b_oard   = board
    p_layers = default_players
    m_ove = move
    HardMode::GameMoment.new(m_ove, symbol, b_oard, p_layers)
  end

  let(:board) do
    Board.new(edge: 3).tap do |brd|
      Board.assign_board_state(brd, board_state)
    end
  end
  let(:win_score) { 10 }
  let(:lose_score) { -10 }
  let(:draw_score) { 0 }
  let(:othr_sym) { '@' }
  let(:call_sym) { 'X' }

  let(:default_players) do
    Players.new.tap do |players|
      players.add(symbol: othr_sym, type: :human)
      players.add(symbol: call_sym, type: :hard)
    end
  end
end
