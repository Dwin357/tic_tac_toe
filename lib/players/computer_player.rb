require_relative 'logic_modules/hard_mode/hard_mode'
require_relative 'logic_modules/medium_mode'
require_relative 'logic_modules/easy_mode'

class ComputerPlayer < AbstractPlayer
  def get_spot(board, players)
    mv = real_move(board, players)
    user_experience(mv)
    mv
  end

  def user_experience(move)
    interface.faux_prompt("#{symbol}'s selection > ")
    sleep(1)
    interface.display(move.to_s)
  end
end

class MediumPlayer < ComputerPlayer
  include MediumMode
end

class HardPlayer < ComputerPlayer
  include HardMode
end

class EasyPlayer < ComputerPlayer
  include EasyMode
end
