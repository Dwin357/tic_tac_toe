require_relative '../../lib/board'

RSpec.describe Board do
  subject { Board.new }

  describe 'object creation' do
    it 'state is assigned' do
      expect(subject.instance_variable_get(:@state)).to eq empty_board
    end
  end

  describe '#show' do
    context 'an empty board' do
      it 'returns an array [0, 1,..7, 8]' do
        expect(subject.display).to eq board_display
      end
    end
    context 'with taken positions' do
      before do
        subject.select(0, 'X')
        board_display[0] = 'X'
        subject.select(4, 'O')
        board_display[4] = 'O'
      end
      it 'fills in selected positions with appropriate symbol' do
        expect(subject.display).to eq board_display
      end
    end
    let(:board_display) { %w(0 1 2 3 4 5 6 7 8) }
  end

  describe '#select' do
    let(:expected_board) do
      Array.new(9).tap { |ary| ary[position] = 'X' }
    end
    let(:position) { rand(9) }
    it 'sets symbol at selected index' do
      expect { subject.select(position, 'X') }
        .to change { subject.instance_variable_get(:@state) }
        .from(empty_board).to(expected_board)
    end
  end

  describe '#game_over?' do
    before { assign_board_state(board) }
    context 'on an empty board' do
      let(:board) { empty_board }
      it 'returns false' do
        expect(subject.game_over?).to be false
      end
    end
    context 'on a full board (no winner)' do
      let(:board) do
        %w(X O X
           X O X
           O X O)
      end
      it 'returns true' do
        expect(subject.game_over?).to be true
      end
    end
    context 'board is partially filled in (no winner)' do
      let(:board) do
        ['X', nil, 'X',
         nil, 'O', 'X',
         'O', 'X', 'O']
      end
      it 'returns false' do
        expect(subject.game_over?).to be false
      end
    end
    context 'vertical win' do
      context 'column one' do
        let(:board) do
          ['X', nil, 'X',
           'X', 'O', 'X',
           'X', 'X', 'O']
        end
        it 'returns true' do
          expect(subject.game_over?).to be true
        end
      end
      context 'column two' do
        let(:board) do
          ['X', 'O', 'X',
           nil, 'O', 'X',
           'X', 'O', 'O']
        end
        it 'returns true' do
          expect(subject.game_over?).to be true
        end
      end
      context 'column three' do
        let(:board) do
          ['X', nil, 'X',
           nil, 'O', 'X',
           'O', 'X', 'X']
        end
        it 'returns true' do
          expect(subject.game_over?).to be true
        end
      end
    end
    context 'horizontil win' do
      context 'row one' do
        let(:board) do
          ['X', 'X', 'X',
           nil, 'O', 'X',
           'O', 'X', 'O']
        end
        it 'returns true' do
          expect(subject.game_over?).to be true
        end
      end
      context 'row two' do
        let(:board) do
          ['X', nil, 'X',
           'O', 'O', 'O',
           'O', 'X', 'O']
        end
        it 'returns true' do
          expect(subject.game_over?).to be true
        end
      end
      context 'row three' do
        let(:board) do
          ['X', nil, 'X',
           nil, 'O', 'X',
           'O', 'O', 'O']
        end
        it 'returns true' do
          expect(subject.game_over?).to be true
        end
      end
    end
    context 'diagonal win' do
      context 'right+up' do
        let(:board) do
          ['X', nil, 'O',
           nil, 'O', 'X',
           'O', 'X', 'O']
        end
        it 'returns true' do
          expect(subject.game_over?).to be true
        end
      end
      context 'right+down' do
        let(:board) do
          ['O', nil, 'X',
           nil, 'O', 'X',
           'O', 'X', 'O']
        end
        it 'returns true' do
          expect(subject.game_over?).to be true
        end
      end
    end
  end

  describe '#winning_move?' do
    before { assign_board_state(board) }

    context 'with no winning moves' do
      let(:board) do
        [nil, nil, 'X',
         nil, 'O', nil,
         'O', 'X', nil]
      end
      it 'returns false' do
        expect(subject.winning_move?(1, 'X')).to be false
      end
    end
    context 'with someone elses winning move' do
      let(:board) do
        ['X', nil, 'X',
         nil, 'O', 'X',
         'O', 'X', 'O']
      end
      it 'returns false' do
        expect(subject.winning_move?(1, 'O')).to be false
      end
    end
    context 'with a winning move' do
      let(:board) do
        ['X', nil, 'X',
         nil, 'O', 'X',
         'O', 'X', 'O']
      end
      it 'returns true' do
        expect(subject.winning_move?(1, 'X')).to be true
      end
    end
  end

  describe '#avaliable_spaces' do
    before { assign_board_state(board) }
    let(:board) do
      ['X', nil, 'X',
       nil, 'O', 'X',
       'O', 'X', 'O']
    end
    it 'returns index of unselected positions' do
      expect(subject.avaliable_spaces).to contain_exactly(1, 3)
    end
  end

  describe '#deep_clone' do
    before { assign_board_state(board) }
    let(:board) do
      ['X', nil, 'X',
       nil, 'O', 'X',
       'O', 'X', 'O']
    end
    it 'returns a board with matching state' do
      expect(subject.deep_clone).to be_a Board
      expect(subject.deep_clone.send(:state)).to eq subject.send(:state)
    end
    it 'changing clone state does not change progenitor state' do
      dopleganger = subject.deep_clone
      expect { dopleganger.select(0, '&') }.not_to change { subject.send(:state) }
    end
  end

  let(:empty_board) { Array.new(9) }
  def assign_board_state(state, board = subject)
    Board.send(:assign_board_state, board, state)
  end
end
