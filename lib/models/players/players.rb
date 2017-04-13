require_relative 'abstract_player'
require_relative '../../cells/players'

class Players
  def initialize
    @players = []
  end

  def add(player_arg)
    players << AbstractPlayer.build(player_arg)
  end

  def active_player(count)
    players[count % 2]
  end

  def other_players_symbol(active_symbol)
    player_symbols.reject { |sym| sym == active_symbol }.first
  end

  def available_symbols
    %w(! @ # $ % ^ & * + =) - player_symbols
  end

  private

  attr_reader :players

  def player_symbols
    players.map { |player| symbol_for player }
  end

  def symbol_for(player)
    player.symbol
  end
end
