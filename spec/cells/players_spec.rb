require_relative '../../lib/models/players/players'

RSpec.describe Players::Cell do
  subject { Players::Cell.new }

  describe 'player_one_title' do
    it 'expected string' do
      msg = "\nPlayer One (ie first to act)\n----------------------------"
      expect(subject.player_one_title).to eq msg
    end
  end
  describe 'player two title' do
    it 'expected string' do
      msg = "\nPlayer Two (ie second to act)\n-----------------------------"
      expect(subject.player_two_title).to eq msg
    end
  end
  describe 'prompt curser' do
    it 'expected string' do
      msg = ' >'
      expect(subject.prompt_curser).to eq msg
    end
  end
  describe 'present type' do
    context 'an error present' do
      let(:errors) { ['Bad Things'] }
      it 'expected string' do
        expected  = "\n"
        expected += "Whoops, that didn't work\n"
        expected += "Bad Things\n"
        expected += "\n"
        expected += "Select player type\n"
        expected += 'Options are: human hard easy medium'

        expect(subject.present_type(errors)).to eq expected
      end
    end
    context 'no errors' do
      let(:errors) { [] }
      it 'expected string' do
        expected  = "Select player type\n"
        expected += 'Options are: human hard easy medium'

        expect(subject.present_type(errors)).to eq expected
      end
    end
  end
  describe 'present symbol' do
    context 'an error present' do
      let(:errors) { ['Bad Things'] }
      it 'expected string' do
        expected  = "\n"
        expected += "Whoops, that didn't work\n"
        expected += "Bad Things\n"
        expected += "\n"
        expected += "Select player symbol (must be unique)\n"
        expected += "Options are: #{available_sym.join(', ')}"

        expect(subject.present_symbol(errors, available_sym)).to eq expected
      end
    end
    context 'no errors' do
      let(:errors) { [] }
      it 'expected string' do
        expected = "Select player symbol (must be unique)\n"
        expected += "Options are: #{available_sym.join(', ')}"

        expect(subject.present_symbol(errors, available_sym)).to eq expected
      end
    end
    let(:available_sym) { Players.new.available_symbols }
  end
  describe 'type_error_msg' do
    it 'expected string' do
      msg = 'Invalid Type choice'
      expect(subject.type_error_msg).to eq msg
    end
  end
  describe 'symbol_error_msg' do
    it 'expected string' do
      msg = 'Invalid Symbol choice'
      expect(subject.symbol_error_msg).to eq msg
    end
  end
end
