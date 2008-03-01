require 'move.rb'

class Round
  @@upper_moves = [:ones, :twos, :threes, :fours, :fives, :sixes]
  @@lower_moves = [:full_house, :small_straight, :large_straight, :three_of_a_kind, :four_of_a_kind, :yahtzee, :chance]

  def initialize()
    @moves = Hash.new
    Array.new(@@upper_moves).concat(@@lower_moves).each {|m| @moves[m] = Move.new(m)}
  end

  def upper_total_raw
    subtotal(@@upper_moves)
  end

  def upper_bonus
    upper_total_raw >= 63 ? 35 : 0
  end

  def upper_total
    upper_total_raw + upper_bonus
  end

  def lower_total
    subtotal(@@lower_moves)
  end

  def grand_total
    lower_total + upper_total
  end

  def score(move)
    raise "No such move \"${move}\"" if @moves[move].nil?
    @moves[move].score
  end

  def make_move(move, dice)
    raise "Illegal move \"${move}\"" if @moves[move].nil?
    @moves[move].make(dice)
  end

  def complete?
    !@moves.any? {|name, move| move.score.nil?}
  end

  def print
    puts "1s\t\t#{score(:ones)}"
    puts "2s\t\t#{score(:twos)}"
    puts "3s\t\t#{score(:threes)}"
    puts "4s\t\t#{score(:fours)}"
    puts "5s\t\t#{score(:fives)}"
    puts "6s\t\t#{score(:sixes)}"
    puts "bonus\t\t#{upper_bonus}"
    puts "upper total\t#{upper_total}"
    puts "3 of a kind\t#{score(:three_of_a_kind)}"
    puts "4 of a kind\t#{score(:four_of_a_kind)}"
    puts "full house\t#{score(:full_house)}"
    puts "small_straight\t#{score(:small_straight)}"
    puts "large_straight\t#{score(:large_straight)}"
    puts "yahtzee\t\t#{score(:yahtzee)}"
    puts "chance\t\t#{score(:chance)}"
    puts "lower total\t#{lower_total}"
    puts "grand total\t#{grand_total}"
  end

  private
  def subtotal(move_set)
    @moves.select {|name, move| move_set.include?(name)}.map {|name, move| move.score}.inject(0){|total, val| total + (val.nil? ? 0 : val)}
  end
end
