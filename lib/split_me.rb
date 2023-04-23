class Rack
  attr_reader :rows

  def initialize
    @rows = Array.new(7) { Array.new(6, '　') }
    @piece = ['🔴', '🟡']
  end

  def four_in_row?
    lines.any? do |line| 
      line.each_cons(4).any? { |a| a.all?(a[0]) unless a[0] == '　'}
    end
  end
  
  def insert_piece(row, r = @rows[row - 1])
    if r.any?('　')
      r[@rows[row - 1].index('　')] = @piece[0]
    else
      false
    end
  end

  private

  def columns
    @rows.transpose
  end

  def diagonals
    rotate_each(@rows, -1, 1) + rotate_each(@rows, 1, -1)
  end

  def lines
    @rows + columns + diagonals
  end

  def rotate_each(arr, shift, n)
    arr.map { |row| row.rotate(n += shift) }.transpose
  end
end


module Display

  def print_rows(r = @rack.rows)
    6.times do |i|
      r.each { |row| print row[-1 - i] }
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
    puts "Player #{@player[-1]} wins!"
  end
end

class Game
  include Display
  
  def initialize
    @rack = Rack.new
    @player = [1, 2]
    @column = ''
  end

  def verify_input
    ask_for_column
    receive_column_choice
    return if input_verified? && @rack.insert_piece(@column.to_i)
    puts_typo
    verify_input
  end

  def play_game
    until @rack.four_in_row? do
      verify_input
      print_rows
      switch_player
    end
    game_over_msg
  end

  def input_verified?
    @column.match?(/^[1-7]$/)
  end

  def receive_column_choice
    @column = gets.chomp
  end

  def switch_player
    @player.reverse!
    @rack.instance_variable_get(:@piece).reverse!
  end
end

# game = Game.new
# game.play_game