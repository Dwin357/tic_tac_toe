class State
  class PrivateConstructor < StandardError; end

  def initialize
    enforce_private_constructor

    @interface = nil
    @board = nil
    @players	 = nil
    @count 		 = nil
    @errors 	 = nil
  end

  attr_accessor :interface, :board, :players, :count, :errors

  def enforce_private_constructor
    raise PrivateConstructor.new('Create using Configuration class')
  end
end
