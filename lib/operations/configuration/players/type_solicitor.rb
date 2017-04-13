require_relative 'abstract_solicitor'

class Players
  class Configuration
    class TypeSolicitor < AbstractSolicitor
      def criteria
        %w(human hard easy medium)
      end

      def present_ask
        cell.present_type(errors)
      end

      def error_msg
        cell.type_error_msg
      end

      def rtn
        response.to_sym
      end
    end
  end
end
