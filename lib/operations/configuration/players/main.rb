require_relative '../../../models/players/players'
require_relative 'symbol_solicitor'
require_relative 'type_solicitor'

class Players
  class Configuration
    class Main
      def initialize
        @players = Players.new
        @cell = Players::Cell.new
      end

      attr_reader :players, :cell

      def configured_players(protostate)
        players.add(player_one(protostate))
        players.add(player_two(protostate))
        players
      end

      def player_arg(proto)
        arg = { interface: proto.interface, symbols: players.available_symbols }
        type = TypeSolicitor.new(arg).ask
        sym = SymbolSolicitor.new(arg).ask
        { type: type, symbol: sym, interface: proto.interface }
      end

      private

      def player_one(proto)
        proto.interface.display(cell.player_one_title)
        player_arg(proto)
      end

      def player_two(proto)
        proto.interface.display(cell.player_two_title)
        player_arg(proto)
      end
    end
  end
end
