class Board
  def initialize(arg)
    @edge  = arg[:edge]
    @state = Array.new(size)
  end

  attr_reader :edge, :state

  def select(index, symbol)
    state[index] = symbol
  end

  def avaliable_spaces
    open_spaces = []
    state.each_with_index do |space, index|
      open_spaces << index if space.nil?
    end
    open_spaces
  end

  def clone
    doppleganger = Board.new(edge: edge)
    Board.assign_board_state(doppleganger, state.clone)
    doppleganger
  end

  def full?
    state.compact.length == size
  end

  def empty?
    state.compact.empty?
  end

  def rows
    rows = Array.new(edge).map { [] }
    state.each_with_index do |el, i|
      rows[i / edge] << el
    end
    rows
  end

  def columns
    col = Array.new(edge).map { [] }
    state.each_with_index do |el, i|
      col[i % edge] << el
    end
    col
  end

  def diagonals
    [descending_diagonal, asscending_diagonal]
  end

  class << self
    def assign_board_state(board, state)
      board.instance_variable_set(:@state, state)
    end
  end

  private

  def asscending_diagonal
    diag = []
    step = (state.length - edge)
    while step > 0
      diag << state[step]
      step -= (edge - 1)
    end
    diag
  end

  def descending_diagonal
    diag  = []
    step  = 0
    while step < state.length
      diag << state[step]
      step += (edge + 1)
    end
    diag
  end

  def size
    edge * edge
  end
end
