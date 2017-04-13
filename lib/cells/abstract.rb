class Abstract
  private

  def board(board_state)
    bored = board_state.state.map.with_index { |el, i| el.nil? ? i.to_s : el }
    show = "\n"
    show += " #{bored[0]} | #{bored[1]} | #{bored[2]}\n"
    show += "===+===+===\n"
    show += " #{bored[3]} | #{bored[4]} | #{bored[5]}\n"
    show += "===+===+===\n"
    show +  " #{bored[6]} | #{bored[7]} | #{bored[8]}\n"
  end

  def errors(error_state)
    error_state.empty? ? '' : present_errors(error_state)
  end

  def iterate_errors(error_state)
    show = ''
    error_state.each do |error|
      show += "#{error}\n"
    end
    show
  end

  def present_errors(errors)
    iterate_errors(errors)
  end
end
