require_relative '../cells/game'

class Game
  class << self
    def play(state)
      state.interface.display(Cell.new.turn_view(state))
      move = active_player(state).get_spot(state.board, state.players)
      successful_turn(move, state) if valid_move?(move, state)
    end

    def resolved?(state)
      over?(state.board)
    end

    def over?(board)
      board.full? || won?(board)
    end

    def won?(board)
      board.columns.any? { |col| winning_line?(col, board) } ||
        board.rows.any? { |row| winning_line?(row, board) } ||
        board.diagonals.any? { |diag| winning_line?(diag, board) }
    end

    private

    def winning_line?(line, board)
      line.compact.count == board.edge && line.all? { |pos| pos == line.first }
    end

    def valid_move?(move, state)
      state.errors = []
      msg = 'Sorry, that move wasnt an option'
      state.errors << msg unless state.board.avaliable_spaces.include? move
      state.errors.empty?
    end

    def successful_turn(move, state)
      state.board.select(move, active_player(state).symbol)
      state.count += 1
    end

    def active_player(state)
      state.players.active_player(state.count)
    end
  end
end
