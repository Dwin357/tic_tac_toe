require_relative '../../models/state'
require_relative '../../interfaces/command_line_interface'
require_relative '../../models/board'
require_relative 'players/main'

class Configuration
  class Main
    class << self
      def initiale_state
        ConfiguredState.new.tap do |state|
          state.count	= 0
          state.interface = CommandLineInterface.new
          state.board 	 	= Board.new(edge: 3)
          state.errors 		= []

          state.players = configured_players(state)
        end
      end

      def test_state(arg = {})
        ConfiguredState.new.tap do |state|
          state.count	= arg[:count]	|| 0
          state.interface = arg[:interface] || CommandLineInterface.new
          state.board 	 	= arg[:board]	|| Board.new(edge: 3)
          state.errors 		= arg[:errors] 		|| []

          state.players = allow_protostate_config(arg[:players], state)
        end
      end

      private

      def configured_players(protostate)
        Players::Configuration::Main.new.configured_players(protostate)
      end

      def allow_protostate_config(player_arg, state)
        if player_arg.nil?
          configured_players(state)
        elsif player_arg == false
          nil
        else
          player_arg
        end
      end
    end
  end
  class ConfiguredState < State
    def enforce_private_constructor; end
  end
end
