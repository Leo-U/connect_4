# frozen_string_literal: true

# contains logic for looping gameplay script
class Game
  include Display

  def initialize
    @rack = Rack.new
    @player = [1, 2]
    @column = ''
  end

  def loop_verify
    ask_for_column
    gets_column_choice
    return if input_verified? && @rack.insert_piece(@column.to_i)
    puts_typo
    loop_verify
  end

  def draw?
    @rack.rows.none? { |row| row.any? '🔲' }
  end

  def input_verified?
    @column.match?(/^[1-7]$/)
  end

  def switch_player
    @player.reverse!
    @rack.instance_variable_get(:@piece).reverse!
  end

  def play_game
    until @rack.four_in_row? || draw?
      loop_verify
      print_rows
      switch_player
    end
    game_over_msg
  end

  private

  def gets_column_choice
    @column = gets.chomp
  end
end
