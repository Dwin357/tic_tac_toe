class Players
  class Configuration
    class AbstractSolicitor
      def initialize(arg)
        @interface = arg[:interface]
        @cell = Players::Cell.new
        @response = nil
        @errors = []
      end

      attr_reader :interface, :response, :cell, :errors

      def ask
        @response = prompt
        @response = prompt until valid_response?
        rtn
      end

      def rtn
        response
      end

      def prompt
        interface.display(present_ask)
        interface.prompt(cursor)
      end

      def present_ask
        # modeled on an annoying child
        errors.empty? ? 'can I' : errors[0] + 'can I'
      end

      def criteria
        # that only accepts one answer
        ['yes']
      end

      def error_msg
        # and refutes all feedback
        'but '
      end

      def valid_response?
        @errors = []
        errors << error_msg unless criteria.include? response
        errors.empty?
      end

      def cursor
        cell.prompt_curser
      end
    end
  end
end
