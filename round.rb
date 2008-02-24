class Round
  def ones=(dice)
    if (@ones.nil?)
      @ones = dice.reject{|d| d != 1}.inject(0) {|sum, val| sum + val}
    end
  end

  def twos=(dice)
    if (@twos.nil?)
      @twos = dice.reject{|d| d != 2}.inject(0) {|sum, val| sum + val}
    end
  end

  def threes=(dice)
    if (@threes.nil?)
      @threes = dice.reject{|d| d != 3}.inject(0) {|sum, val| sum + val}
    end
  end

  def fours=(dice)
    if (@fours.nil?)
      @fours = dice.reject{|d| d != 4}.inject(0) {|sum, val| sum + val}
    end
  end

  def fives=(dice)
    if (@fives.nil?)
      @fives = dice.reject{|d| d != 5}.inject(0) {|sum, val| sum + val}
    end
  end

  def sixes=(dice)
    if (@sixes.nil?)
      @sixes = dice.reject{|d| d != 6}.inject(0) {|sum, val| sum + val}
    end
  end

  def full_house=(dice)
    if (@full_house.nil?)
      dice.sort!
      if (dice.uniq.length == 2 && (dice[0] == dice[1]) && (dice[-1] == dice[-2]))
        @full_house = 25
      else
        @full_house = 0
      end
    end
  end

  def small_straight=(dice)
    if (@small_straight.nil?)
      sorted_dice = dice.uniq.sort
      if (sorted_dice[0..3] == [1, 2, 3, 4] || sorted_dice[0..3] == [2, 3, 4, 5] || sorted_dice[1..4]== [3, 4, 5, 6])
        @small_straight = 40
      else
        @small_straight = 0
      end
    end
  end

  def large_straight=(dice)
    if (@large_straight.nil?)
      dice.sort!
      if (dice == [1, 2, 3, 4, 5] || dice == [2, 3, 4, 5, 6])
        @large_straight = 40
      else
        @large_straight = 0
      end
    end
  end

  def three_of_a_kind=(dice)
    if (@three_of_a_kind.nil?)
      dice.sort!
      if (dice.reject{|d| d != dice[2]}.length >= 3)
        @three_of_a_kind = dice.inject() {|sum, val| sum + val}
      else
        @full_house = 0
      end
    end
  end

  def four_of_a_kind=(dice)
    if (@four_of_a_kind.nil?)
      dice.sort!
      if (dice.reject{|d| d != dice[2]}.length >= 4)
        @four_of_a_kind = dice.inject() {|sum, val| sum + val}
      else
        @full_house = 0
      end
    end
  end

  #fixme (can score yahtzees >1)
  def yahtzee=(dice)
    if (@yahtzee.nil?)
      num = dice[0];
      if (dice == Array.new(5, num))
        @yahtzee = 50
      else
        @yahtzee = 0
      end
    end
  end

  def chance=(dice)
    if (@chance.nil?)
      @chance = dice.inject() {|sum, val| sum + val}
    end
  end

  def upper_bonus
    upper_total_raw > 63 ? 35 : 0
  end

  def upper_total_raw
    total = 0
    total += @ones if @ones
    total += @twos if @twos
    total += @threes if @threes
    total += @fours if @fours
    total += @fives if @fives
    total += @sixes if @sixes
    total
  end

  def upper_total
    upper_total_raw + upper_bonus
  end

  def lower_total
    total = 0
    total += @full_house if (@full_house)
    total += @three_of_a_kind if (@three_of_a_kind)
    total += @four_of_a_kind if (@four_of_a_kind)
    total += @small_straight if (@small_straight)
    total += @large_straight if (@large_straight)
    total += @chance if (@chance)
    total += @yahtzee if (@yahtzee)
    total
  end

  def score
    lower_total + upper_total
  end

  attr_reader :ones, :twos, :threes, :fours, :fives, :sixes, :three_of_a_kind, :four_of_a_kind, :full_house, :small_straight, :large_straight, :chance, :yahtzee
end
