require_relative 'abstract'

class Players
  class Cell < Abstract
    def player_one_title
      "\nPlayer One (ie first to act)\n----------------------------"
    end

    def player_two_title
      "\nPlayer Two (ie second to act)\n-----------------------------"
    end

    def present_symbol(errors, symbols)
      errors(errors) + symbol_prompt(symbols)
    end

    def present_type(errors)
      errors(errors) + type_prompt
    end

    def prompt_curser
      ' >'
    end

    def type_error_msg
      'Invalid Type choice'
    end

    def symbol_error_msg
      'Invalid Symbol choice'
    end

    private

    def present_errors(errors)
      "\nWhoops, that didn't work\n" + iterate_errors(errors) + "\n"
    end

    def type_prompt
      "Select player type\nOptions are: human hard easy medium"
    end

    def symbol_prompt(symbols)
      present = "Select player symbol (must be unique)\n"
      present + "Options are: #{symbols.join(', ')}"
    end
  end
end
