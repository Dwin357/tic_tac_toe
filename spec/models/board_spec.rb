require_relative '../../lib/models/board'

RSpec.describe Board do
  subject { Board.new(edge: edge) }

  describe 'object creation' do
    it 'sets edge' do
      expect(subject.edge).to eq edge
    end
    it 'sets state' do
      expect(subject.state).to eq empty_board_state
    end
  end

  describe '.assign_board_state' do
    let(:passed_state) do
      Array.new(9).tap { |ary| ary[rand(9)] = 'X' }
    end
    it 'changes state of passed board' do
      expect { Board.assign_board_state(subject, passed_state) }
        .to change { subject.state }.from(empty_board_state).to(passed_state)
    end
  end

  describe '#select' do
    let(:expected_board) do
      Array.new(9).tap { |ary| ary[position] = 'X' }
    end
    let(:position) { rand(9) }
    it 'sets symbol at selected index' do
      expect { subject.select(position, 'X') }
        .to change { subject.state }
        .from(empty_board_state).to(expected_board)
    end
  end

  describe '#avaliable_spaces' do
    before { Board.assign_board_state(subject, state) }
    let(:state) do
      ['X', nil, 'X',
       nil, '@', 'X',
       '@', 'X', '@']
    end
    it 'returns indexs of unselected positions' do
      expect(subject.avaliable_spaces).to contain_exactly(1, 3)
    end
  end

  describe '#clone' do
    before { Board.assign_board_state(subject, state) }
    let(:state) do
      ['X', nil, 'X',
       nil, '@', 'X',
       '@', 'X', '@']
    end
    describe 'object state' do
      it 'preserves edge' do
        original     = subject
        doppleganger = subject.clone
        expect(doppleganger.edge).to eq original.edge
      end
      it 'preserves state' do
        original     = subject
        doppleganger = subject.clone
        expect(doppleganger.state).to eq original.state
      end
    end
    describe 'unique object' do
      it 'change of doppleganger doesnt change original' do
        original     = subject
        doppleganger = subject.clone
        expect { doppleganger.select(1, '@') }.not_to change { original.state }
      end
    end
  end

  describe '#full?' do
    context 'board has open positions' do
      before { Board.assign_board_state(subject, state) }
      let(:state) do
        ['X', nil, 'X',
         nil, '@', 'X',
         '@', 'X', '@']
      end
      it 'false' do
        expect(subject.full?).to be false
      end
    end
    context 'board has no open positions' do
      before { Board.assign_board_state(subject, state) }
      let(:state) do
        ['X', '@', 'X',
         '@', '@', 'X',
         '@', 'X', '@']
      end
      it 'true' do
        expect(subject.full?).to be true
      end
    end
  end

  describe '#empty?' do
    context 'board has filled positions' do
      before { Board.assign_board_state(subject, state) }
      let(:state) do
        ['X', nil, 'X',
         nil, '@', 'X',
         '@', 'X', '@']
      end
      it 'false' do
        expect(subject.empty?).to be false
      end
    end
    context 'board has no filled positions' do
      before { Board.assign_board_state(subject, state) }
      let(:state) { empty_board_state }
      it 'true' do
        expect(subject.empty?).to be true
      end
    end
  end

  describe '#rows' do
    before { Board.assign_board_state(subject, state) }
    let(:state) do
      ['X', nil, 'X',
       nil, '@', 'X',
       '@', 'X', '@']
    end
    it 'returns the rows' do
      expected = [['X', nil, 'X'], [nil, '@', 'X'], ['@', 'X', '@']]
      expect(subject.rows).to eq expected
    end
  end

  describe '#columns' do
    before { Board.assign_board_state(subject, state) }
    let(:state) do
      ['X', nil, 'X',
       nil, '@', 'X',
       '@', 'X', '@']
    end
    it 'returns the columns' do
      expected = [['X', nil, '@'], [nil, '@', 'X'], ['X', 'X', '@']]
      expect(subject.columns).to eq expected
    end
  end

  describe '#diagonals' do
    before { Board.assign_board_state(subject, state) }
    let(:state) do
      ['X', nil, 'X',
       nil, '@', 'X',
       '@', 'X', '@']
    end
    it 'returns the diagonals' do
      expected = [['X', '@', '@'], ['@', '@', 'X']]
      expect(subject.diagonals).to eq expected
    end
  end

  let(:empty_board_state) { Array.new(edge * edge) }
  let(:edge) { 3 }
end
