require_relative 'configuration/main'
require_relative 'game'
require_relative 'resolution'

class Operation
  class Main
    def run
      state = Configuration::Main.initiale_state
      Game.play(state) until Game.resolved?(state)
      Resolution.wrap_up(state)
    end
  end
end
