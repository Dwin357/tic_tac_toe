require_relative 'abstract_solicitor'

class Players
  class Configuration
    class SymbolSolicitor < AbstractSolicitor
      def initialize(arg)
        @symbols = arg[:symbols]
        super(arg)
      end

      attr_reader :symbols

      def criteria
        symbols
      end

      def error_msg
        cell.symbol_error_msg
      end

      def present_ask
        cell.present_symbol(errors, symbols)
      end
    end
  end
end
