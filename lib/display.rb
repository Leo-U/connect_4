# frozen_string_literal: true

# prints messages and board to player
module Display
  private

  def print_rows(rows = @rack.rows)
    6.times do |i|
      rows.each { |row| print row[-1 - i] }
      puts
    end
  end

  def ask_for_column
    puts "Player #{@player[0]}, choose a column 1 thru 7."
  end

  def puts_typo
    puts 'Typo or column full. Try again.'
  end

  def game_over_msg
    puts @rack.four_in_row? ? "Player #{@player[-1]} wins!" : 'Draw!'
  end
end
