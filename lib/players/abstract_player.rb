class AbstractPlayer
  def initialize(arg)
    @symbol    = arg[:symbol]
    @interface = arg[:interface]
  end

  attr_reader :symbol

  def self.build(arg)
    case arg[:type]
    when :human
      HumanPlayer.new(arg)
    when :hard
      HardPlayer.new(arg)
    when :medium
      MediumPlayer.new(arg)
    when :easy
      EasyPlayer.new(arg)
    end
  end

  private

  attr_reader :interface
end

require_relative 'human_player'
require_relative 'computer_player'
