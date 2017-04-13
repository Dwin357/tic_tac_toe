module HardMode
  class GameMoment
    def initialize(m_ove, a_ctor, b_oard, p_layers)
      @move = m_ove
      @actor 	 = a_ctor
      @board 	 = b_oard
      @players = p_layers
    end

    attr_accessor :move, :actor, :board, :players
  end
end
