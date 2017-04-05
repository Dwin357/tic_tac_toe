class HumanPlayer < AbstractPlayer
  def get_spot(_, _)
    interface.prompt("#{symbol}'s selection > ").to_i
  end
end
