require_relative 'players/players'
require_relative 'board'

class GameState
  def initialize(arg)
    @board     = Board.new
    @players   = Players.new
    @interface = arg[:interface]

    @errors = []

    @config_step    = 0
    @count          = 0
    @tear_down_step = 0
  end

  def resolve_turn
    player = players.active_player(count)
    set_up_move
    move = player.get_spot(board, players)
    successful_turn(move) if valid_move?(move, board)
  end

  def game_over?
    board.game_over?
  end

  def next_configuration
    case config_step
    when 0
      configure_players
    end
    increment_config_step
  end

  def configured?
    config_step >= 1
  end

  def torn_down?
    tear_down_step >= 1
  end

  def next_tear_down
    case tear_down_step
    when 0
      interface.display(show_board(board))
      interface.display(exit_message)
    end
    increment_tear_down_step
  end

  private

  attr_reader :tear_down_step, :config_step, :count, :players, :board
  attr_reader :interface, :errors

  def successful_turn(move)
    board.select(move, players.active_player(count).symbol)
    increment_count
  end

  def exit_message
    msg = "Game over\n"
    msg += (board.game_won? ? win_msg : draw_msg)
    msg + "\n"
  end

  def win_msg
    winner = players.active_player(count - 1)
    "Congratulations!!! #{winner.symbol}"
  end

  def draw_msg
    'Good game, better luck next time'
  end

  def set_up_move
    interface.display(show_board(board))
    if errors.any?
      errors.each do |error|
        interface.display error
      end
    end
    interface.display('Select your move')
    interface.display('Options are ' + board.avaliable_spaces.to_s)
  end

  def valid_move?(move, board)
    @errors = []
    msg = 'Sorry, that move wasnt an option'
    errors << msg unless board.avaliable_spaces.include? move
    errors.empty?
  end

  def configure_players
    players.next_configuration(interface) until players.configured?
  end

  def show_board(board_state)
    board = board_state.display
    show  = "\n "
    show += "#{board[0]} | #{board[1]} | #{board[2]}"
    show += " \n===+===+===\n "
    show += "#{board[3]} | #{board[4]} | #{board[5]}"
    show += " \n===+===+===\n "
    show += "#{board[6]} | #{board[7]} | #{board[8]}"
    show +  " \n"
  end

  def increment_tear_down_step
    @tear_down_step += 1
  end

  def increment_config_step
    @config_step += 1
  end

  def increment_count
    @count += 1
  end
end
