require_relative 'game_moment'
require_relative 'decision_node'

module HardMode
  def real_move(board, players)
    root_node(board, players).posibilities.sort.first.move
  end

  private

  def root_node(board, players)
    mv = nil
    sym = adjust_node_posibilities_to_own_perspective(players)
    brd = board.deep_clone
    ply = players
    DecisionNode.new(GameMoment.new(mv, sym, brd, ply))
  end

  def adjust_node_posibilities_to_own_perspective(players)
    players.other_players_symbol(symbol)
  end

  def module_id
    HardMode
  end
end
