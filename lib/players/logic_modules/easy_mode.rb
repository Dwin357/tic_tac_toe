module EasyMode
  def real_move(board, _)
    board.avaliable_spaces.sample
  end

  private

  def module_id
    EasyMode
  end
end
