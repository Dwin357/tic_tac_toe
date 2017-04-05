module MediumMode
  def real_move(board, players)
    open_spaces = board.avaliable_spaces
    other_symbol = players.other_players_symbol(symbol)

    if open_middle?(open_spaces)
      pick_middle_space
    elsif winning_move?(open_spaces, board)
      pick_winning_move(open_spaces, board)
    elsif about_to_lose?(open_spaces, board, other_symbol)
      pick_winning_move_block(open_spaces, board, other_symbol)
    else
      pick_random_move(open_spaces)
    end
  end

  private

  def module_id
    MediumMode
  end

  def winning_move?(open_spaces, board)
    open_spaces.any? { |space| board.winning_move?(space, symbol) }
  end

  def about_to_lose?(open_spaces, board, other_symbol)
    open_spaces.any? { |space| board.winning_move?(space, other_symbol) }
  end

  def open_middle?(open_spaces)
    open_spaces.include?(4)
  end

  def pick_winning_move(open_spaces, board)
    open_spaces.each do |space|
      return space if board.winning_move?(space, symbol)
    end
  end

  def pick_winning_move_block(open_spaces, board, other_symbol)
    open_spaces.each do |space|
      return space if board.winning_move?(space, other_symbol)
    end
  end

  def pick_middle_space
    4
  end

  def pick_random_move(open_spaces)
    open_spaces[rand(0..open_spaces.length)]
  end
end
