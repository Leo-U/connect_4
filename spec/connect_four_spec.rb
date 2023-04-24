require_relative '../lib/rack'
require_relative '../lib/display'
require_relative '../lib/game'

describe Rack do
  let(:state) { Array.new(7) { Array.new(6, '🔲') } }

  describe '#four_in_row?' do
    subject(:rack_row) { described_class.new }
    let(:set_state) { rack_row.instance_variable_set(:@rows, state) }
    let(:print_state) { rack_row.instance_variable_get(:@rows).each { |row| p row } }

    context 'when there are none in a row' do
      it 'returns false' do
        print_state
        expect(rack_row.four_in_row?).to be false
      end
    end

    context 'when there is a descending diagonal' do
      it 'returns true' do
        state[2][2], state[3][3], state[4][4], state[5][5] = ['⬛'] * 4
        set_state
        print_state
        expect(rack_row.four_in_row?).to be true
      end
    end

    context 'when there is an ascending diagonal' do
      it 'returns true' do
        state[0][3], state[1][2], state[2][1], state[3][0] = ['⬛'] * 4
        set_state
        print_state
        expect(rack_row.four_in_row?).to be true
      end
    end
    
    context 'when there is a row' do
      it 'returns true' do
        state[3][1], state[3][2], state[3][3], state[3][4] = ['⬛'] * 4
        set_state
        print_state
        expect(rack_row.four_in_row?).to be true
      end
    end

    context 'when there is a column' do
      it 'returns true' do
        state[1][1], state[2][1], state[3][1], state[4][1] = ['⬛'] * 4
        set_state
        print_state
        expect(rack_row.four_in_row?).to be true
      end
    end
  end

  describe '#insert_piece' do
    subject(:rack_insert) { described_class.new }
    let(:print_state) { rack_insert.instance_variable_get(:@rows).each { |row| p row } }
    let(:set_state) { rack_insert.instance_variable_set(:@rows, state) }

    context 'when space available' do
      it 'puts the piece in the stack' do
        state[0][0] = '⬛'
        expect { rack_insert.insert_piece(1) }.to change { rack_insert.instance_variable_get(:@rows)}.to(state)
        print_state
      end
    end

    context 'when space not available' do
      it 'returns false' do
        (0..5).each { |i| state[0][i] = '⬛' }
        set_state
        print_state
        expect(rack_insert.insert_piece(1)).to be false
      end
    end

    context 'when input is 7' do
      it 'puts the piece in' do
        state[6][0] = '⬛'
        expect { rack_insert.insert_piece(7) }.to change { rack_insert.instance_variable_get(:@rows)}.to(state)
        print_state
      end
    end
  end

end

describe Game do
  let(:state) { Array.new(7) { Array.new(6, '🔲') } }

  describe '#input_verified' do
    subject(:game_verified) { described_class.new }

    context 'when input is invalid' do
      it 'returns false' do
        expect(game_verified.input_verified?).to be false
      end
    end

    context 'when input is valid' do
      it 'returns true' do
        game_verified.instance_variable_set(:@column, '4')
        expect(game_verified.input_verified?).to be true
      end
    end
  end

  describe 'loop_verify' do
    subject(:game_verify) { described_class.new }
    context 'when incorrect answer is input twice, then correct answer' do
      it 'prints error twice and completes loop' do
        allow(game_verify).to receive(:gets).and_return('foo', 'bar', '5')
        allow(game_verify).to receive(:ask_for_column)
        expect(game_verify).to receive(:puts_typo).twice
        game_verify.loop_verify
      end
    end
  end

  describe '#draw?' do
    subject(:game_draw) { described_class.new }
    let(:rack) { game_draw.instance_variable_get(:@rack) }
    let(:letters) { ('A'..'Z').to_a + ('a'..'p').to_a }
    let(:update_state) { state.each { |row| row.map! { |el| el = letters.shift } } }

    before do
      update_state
    end

    context "when rack is full and there aren't four in a row" do
      it 'returns true' do
        rack.instance_variable_set(:@rows, state)        
        expect(game_draw.draw?).to be true
      end
    end
  end

  describe '#switch_player' do
    subject(:game_switch) { described_class.new }
    let(:rack) { game_switch.instance_variable_get(:@rack) }

    context 'when current player is 1' do
      it 'switches the player to 2' do
        expect { game_switch.switch_player }.to change { game_switch.instance_variable_get(:@player)[0] }.from(1).to(2)
      end
    end

    context 'when piece is red' do
      it 'switches the piece to brown' do
        expect { game_switch.switch_player }.to change { rack.instance_variable_get(:@piece)[0] }.from('⬛').to('🟫')
      end
    end
  end

  describe '#play_game' do
    subject(:game_play) { described_class.new }
    let(:draw_sequence) do
      [['1','2'],['2','1'],['3','4'],['4','3'],['5','6'],['6','5']].map do |ar|
        ar * 3
      end.flatten + ['7'] * 6
    end
    let(:full_win_sequence) do
      ((1..7).to_a * 3 + (2..7).to_a * 2 + [3,1,7,6,5,4,1,1,2]).map(&:to_s)
    end
    let(:partial_win_sequence) do
      ((1..7).to_a * 3 + [1]).map(&:to_s)
    end

    before do
      allow(game_play).to receive(:ask_for_column)
    end

    context 'when game reaches a drawn position' do
      it 'ends loop and prints draw message' do
        allow(game_play).to receive(:gets).and_return(*draw_sequence)
        expect(game_play).to receive(:print_rows).exactly(42).times
        game_play.play_game
      end
    end

    context 'when game reaches a won position with full rack' do
      it 'ends loop and prints win message' do
        allow(game_play).to receive(:gets).and_return(*full_win_sequence)
        expect(game_play).to receive(:print_rows).exactly(42).times
        game_play.play_game
      end
    end 

    context 'when game reaches a won position when rack is partially filled' do
      it 'ends loop and prints win message' do
        allow(game_play).to receive(:gets).and_return(*partial_win_sequence)
        expect(game_play).to receive(:print_rows).exactly(22).times
        game_play.play_game
      end
    end
  end
end
