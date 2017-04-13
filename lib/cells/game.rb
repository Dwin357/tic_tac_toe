require_relative 'abstract'

class Game
  class Cell < Abstract
    def turn_view(state)
      present  = board(state.board)
      present += errors(state.errors)
      present +  prompt(state.board)
    end

    private

    def prompt(board_state)
      show = "Select your move\n"
      show + "Options are #{board_state.avaliable_spaces}\n"
    end
  end
end
