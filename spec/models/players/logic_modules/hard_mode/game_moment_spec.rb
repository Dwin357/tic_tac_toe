require_relative '../../../../../lib/models/players/logic_modules/hard_mode/game_moment'
require_relative '../../../../../lib/models/board'
require_relative '../../../../../lib/models/players/players'

RSpec.describe HardMode::GameMoment do
  subject { HardMode::GameMoment.new(move, actor, board, players) }

  describe 'object creation and readers' do
    it 'move assigned and readable' do
      expect(subject.move).to eq move
    end
    it 'actor assigned and readable' do
      expect(subject.actor).to eq actor
    end
    it 'board assigned and readable' do
      expect(subject.board).to eq board
    end
    it 'players assigned and readable' do
      expect(subject.players).to eq players
    end
  end
  let(:move) { rand(9) }
  let(:actor) { ['!', '@', '#', '$', '%', '^', '&', '*'].sample }
  let(:board) { Board.new(edge: 3) }
  let(:players) { Players.new }
end
