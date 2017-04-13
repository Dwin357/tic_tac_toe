require_relative 'game'
require_relative '../cells/resolution'

class Resolution < Game
  class << self
    def wrap_up(state)
      state.interface.display(resolution_msg(state))
    end

    private

    def resolution_msg(state)
      won?(state.board) ? Cell.new.win_msg(state) : Cell.new.draw_msg(state)
    end
  end
end
