class Board
  def initialize
    @state = Array.new(9)
  end

  def display
    state.map.with_index do |element, index|
      element.nil? ? index.to_s : element
    end
  end

  def select(index, symbol)
    state[index] = symbol
  end

  def game_over?
    game_won? || board_full?
  end

  def game_won?
    game_is_won?(state)
  end

  def winning_move?(index, symbol)
    board = state.clone
    board[index] = symbol
    game_is_won?(board)
  end

  def avaliable_spaces
    open_spaces = []
    state.each_with_index do |space, index|
      open_spaces << index if space.nil?
    end
    open_spaces
  end

  def deep_clone
    dopleganger = clone
    the_goods = state.clone
    Board.send(:assign_board_state, dopleganger, the_goods)
    dopleganger
  end

  class << self
    private

    def assign_board_state(board, state)
      board.instance_variable_set(:@state, state)
    end
  end

  private

  attr_reader :state

  def board_full?
    state.compact.length == 9
  end

  def game_is_won?(b)
    column_win?(b) || row_win?(b) || diagonal_win?(b)
  end

  def winning_set?(p1, p2, p3)
    !p1.nil? && (p1 == p2) && (p2 == p3)
  end

  def column_win?(b)
    column_1_win?(b) || column_2_win?(b) || column_3_win?(b)
  end

  def row_win?(b)
    row_1_win?(b) || row_2_win?(b) || row_3_win?(b)
  end

  def diagonal_win?(b)
    diagonal_up_win?(b) || diagonal_down_win?(b)
  end

  def column_1_win?(b)
    winning_set?(b[0], b[3], b[6])
  end

  def column_2_win?(b)
    winning_set?(b[1], b[4], b[7])
  end

  def column_3_win?(b)
    winning_set?(b[2], b[5], b[8])
  end

  def row_1_win?(b)
    winning_set?(b[0], b[1], b[2])
  end

  def row_2_win?(b)
    winning_set?(b[3], b[4], b[5])
  end

  def row_3_win?(b)
    winning_set?(b[6], b[7], b[8])
  end

  def diagonal_up_win?(b)
    winning_set?(b[6], b[4], b[2])
  end

  def diagonal_down_win?(b)
    winning_set?(b[0], b[4], b[8])
  end
end
