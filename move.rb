#fixme (can score yahtzees >1)
class Move
  def initialize(move_type)
    @move_type = move_type
  end

  def make(dice)
    raise "Already made this move" if (!@score.nil?)
    @score = send(@move_type, dice)
  end

  attr_reader :score

  private

  def ones(dice)
    dice.reject{|d| d != 1}.inject(0) {|sum, val| sum + val}
  end

  def twos(dice)
    dice.reject{|d| d != 2}.inject(0) {|sum, val| sum + val}
  end

  def threes(dice)
    dice.reject{|d| d != 3}.inject(0) {|sum, val| sum + val}
  end

  def fours(dice)
    dice.reject{|d| d != 4}.inject(0) {|sum, val| sum + val}
  end

  def fives(dice)
    dice.reject{|d| d != 5}.inject(0) {|sum, val| sum + val}
  end

  def sixes(dice)
    dice.reject{|d| d != 6}.inject(0) {|sum, val| sum + val}
  end

  def full_house(dice)
    dice.sort!
    dice.uniq.length == 2 && (dice[0] == dice[1]) && (dice[-1] == dice[-2]) ? 25 : 0
  end

  def small_straight(dice) 
    sorted_dice = dice.uniq.sort
    sorted_dice[0..3] == [1, 2, 3, 4] || sorted_dice[0..3] == [2, 3, 4, 5] || sorted_dice[1..4]== [3, 4, 5, 6] ? 30 : 0
  end

  def large_straight(dice)
    dice.sort!
    dice == [1, 2, 3, 4, 5] || dice == [2, 3, 4, 5, 6] ? 40 : 0
  end

  def three_of_a_kind(dice)
    dice.reject{|d| d != dice.sort[2]}.length >= 3 ? dice.inject() {|sum, val| sum + val} : 0
  end

  def four_of_a_kind(dice)
    dice.reject{|d| d != dice.sort[2]}.length >= 4 ? dice.inject() {|sum, val| sum + val} : 0
  end

  def yahtzee(dice)
    dice == Array.new(5, dice[0]) ? 50 : 0
  end

  def chance(dice)
    dice.inject() {|sum, val| sum + val}
  end
end
