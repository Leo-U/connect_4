# frozen_string_literal: true

# contains rack state
class Rack
  attr_reader :rows

  def initialize
    @rows = Array.new(7) { Array.new(6, '🔲') }
    @piece = ['⬛', '🟫']
  end

  def four_in_row?
    lines.any? do |line|
      line.each_cons(4).any? { |a| a.all?(a[0]) unless a[0] == '🔲' }
    end
  end

  def insert_piece(row, rows = @rows[row - 1])
    rows.any?('🔲') ? rows[rows.index('🔲')] = @piece[0] : false
  end

  private

  def columns
    @rows.transpose
  end

  def diagonals
    rotate_each(pad, -1, 1) + rotate_each(pad('l'), 1, -1)
  end

  def lines
    @rows + columns + diagonals
  end

  def rotate_each(arr, shift, base)
    arr.map { |row| row.rotate(base += shift) }.transpose
  end

  def pad(side = 'r', pad = ['🔲'] * 6)
    @rows.map { |row| side == 'r' ? row + pad : pad + row }
  end
end
