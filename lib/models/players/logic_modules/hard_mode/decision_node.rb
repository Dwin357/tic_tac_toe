require_relative 'game_moment'
require_relative '../../../../operations/game'

module HardMode
  class DecisionNode
    def initialize(moment)
      @move					= moment.move
      @actor				= moment.actor
      @posibilities = build_posibilities(moment)
      @move_score   = build_move_score(posibilities, moment)
    end

    attr_reader :move, :actor, :posibilities, :move_score

    def build_posibilities(moment)
      return [] if Game.over?(moment.board)

      moment.board.avaliable_spaces.map do |space|
        spc = space
        sym = moment.players.other_players_symbol(actor)
        ply = moment.players
        brd = moment.board.clone
        brd.select(spc, sym)
        DecisionNode.new(GameMoment.new(spc, sym, brd, ply))
      end
    end

    def build_move_score(posibilities, moment)
      if Game.over?(moment.board)
        generate_score(moment)
      else
        account_for_preference(forecast_outcomes(posibilities))
      end
    end

    def generate_score(moment)
      Game.won?(moment.board) ? 10 : 0
    end

    def forecast_outcomes(posibilities)
      posibilities.sort.first.move_score
    end

    def account_for_preference(other_persons_preference)
      -1 * other_persons_preference
    end

    def <=>(other)
      if move_score > other.move_score
        -1
      elsif other.move_score > move_score
        1
      else
        0
      end
    end
  end
end
