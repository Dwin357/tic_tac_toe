require_relative 'abstract_player'

class Players
  def initialize
    @players = []

    @config_step = 0
    @errors = []
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

  def configured?
    @config_step >= 2
  end

  def next_configuration(interface)
    arg = { interface: interface }

    interface.display(title(config_step))
    prompt_for_symbol(interface, arg)
    prompt_for_type(interface, arg)

    if validate_player_arg?(arg)
      add(arg)
      increment_config_step
    else
      interface.display("\nWhoops, that didn't work")
      errors.each do |error|
        interface.display(error)
      end
    end
  end

  private

  attr_reader :players, :config_step, :errors

  def player_symbols
    players.map { |p| symbol_for p }
  end

  def symbol_for(player)
    player.symbol
  end

  def title(player_position)
    case player_position
    when 0
      "\nPlayer One (ie first to act)\n----------------------------"
    when 1
      "\nPlayer Two (ie second to act)\n-----------------------------"
    end
  end

  def prompt_for_symbol(interface, arg)
    interface.display('Select player symbol (must be unique)')
    interface.display('Options are: ! @ # $ % ^ & * + =')
    arg[:symbol] = interface.prompt(' >')
  end

  def prompt_for_type(interface, arg)
    interface.display('Select player type')
    interface.display('Options are: human hard easy medium')
    arg[:type] = interface.prompt(' >').to_sym
  end

  def validate_player_arg?(arg)
    valid_types = [:human, :hard, :easy, :medium]
    valid_symbols = %w(! @ # $ % ^ & * + =) - player_symbols

    @errors = []
    errors << 'Invalid Symbol choice' unless valid_symbols.include? arg[:symbol]
    errors << 'Invalid Type choice' unless valid_types.include? arg[:type]

    errors.empty?
  end

  def increment_config_step
    @config_step += 1
  end
end
