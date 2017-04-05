require_relative 'game_state'
require_relative 'interfaces/command_line_interface'

class GameRepel
  def initialize
    @game_state = GameState.new(interface: CommandLineInterface.new)
  end

  def start_game
    game_state.next_configuration until game_state.configured?

    game_state.resolve_turn until game_state.game_over?

    game_state.next_tear_down until game_state.torn_down?
  end

  private

  attr_reader :game_state
end
