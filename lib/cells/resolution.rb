require_relative 'abstract'

class Resolution < Game
  class Cell < Abstract
    def win_msg(state)
      winner = last_acting_player(state)

      present  = board(state.board)
      present += "Game over\n"
      present +  "Congratulations!!! #{winner.symbol}\n"
    end

    def draw_msg(state)
      present = board(state.board)
      present += "Game over\n"
      present +  "Good game, better luck next time\n"
    end

    private

    def last_acting_player(state)
      last_acting_count = state.count - 1
      state.players.active_player(last_acting_count)
    end
  end
end
