#!/usr/bin/ruby

class Die
  def initialize
    roll
  end

  def roll
    @num = rand(6) + 1
  end

  def to_s
    @num
  end

  attr_reader :num
end

class YahtzeeGame
  def initialize
    @dice = [Die.new, Die.new, Die.new, Die.new, Die.new]
  end

  def roll(reroll_dice = @dice)
    reroll_dice.each do | die | die.roll end
  end

  attr_reader :dice
end

class Player
  def initialize(game)
    @state = 0
    @game = game
    @round = Round.new
  end

  def start_turn
    if (@state == 0)
      @game.roll
      @state = @state + 1
    end
  end

  def refine(reroll_dice)
    if (@state > 0 && @state < 3)
      @game.roll(reroll_dice)
      @state = @state + 1
    end
  end

  def score(type_string)
    if (@state > 0)
      @state = 0
      case type_string
      when "1" then @round.ones = @game.dice.map{|d| d.num}
      when "2" then @round.twos = @game.dice.map{|d| d.num}
      when "3" then @round.threes = @game.dice.map{|d| d.num}
      when "4" then @round.fours = @game.dice.map{|d| d.num}
      when "5" then @round.fives = @game.dice.map{|d| d.num}
      when "6" then @round.sixes = @game.dice.map{|d| d.num}
      when "s" then @round.small_straight = @game.dice.map{|d| d.num}
      when "l" then @round.large_straight = @game.dice.map{|d| d.num}
      when "h" then @round.full_house = @game.dice.map{|d| d.num}
      when "t" then @round.three_of_a_kind = @game.dice.map{|d| d.num}
      when "f" then @round.four_of_a_kind = @game.dice.map{|d| d.num}
      when "y" then @round.yahtzee = @game.dice.map{|d| d.num}
      when "?" then @round.chance = @game.dice.map{|d| d.num}
      else -1
      end
    end
  end

  def print_board
    puts "1s\t\t#{@round.ones}"
    puts "2s\t\t#{@round.twos}"
    puts "3s\t\t#{@round.threes}"
    puts "4s\t\t#{@round.fours}"
    puts "5s\t\t#{@round.fives}"
    puts "6s\t\t#{@round.sixes}"
    puts "bonus\t\t#{@round.upper_bonus}"
    puts "upper total\t#{@round.upper_total}"
    puts "3 of a kind\t#{@round.three_of_a_kind}"
    puts "4 of a kind\t#{@round.four_of_a_kind}"
    puts "full house\t#{@round.full_house}"
    puts "small_straight\t#{@round.small_straight}"
    puts "large_straight\t#{@round.large_straight}"
    puts "yahtzee\t\t#{@round.yahtzee}"
    puts "chance\t\t#{@round.chance}"
    puts "lower total\t#{@round.lower_total}"
    puts "grand total\t#{@round.score}"
  end
end

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

game = YahtzeeGame.new
player = Player.new(game)
while (true)
  player.start_turn
  puts "You have rolled #{game.dice.map {|d| d.num}.join(', ')}"
  command = $stdin.gets
  reroll_dice = Array.new
  command.each_byte {|s| if (s >= 49 && s <= 54) then reroll_dice << game.dice[s-49] end }
  #puts "dice are #{reroll_dice.join(', ')}"
  player.refine(reroll_dice)
  puts "You have rolled #{game.dice.map {|d| d.num}.join(', ')}"
  command = $stdin.gets
  reroll_dice.clear
  command.each_byte {|s| if (s >= 49 && s <= 54) then reroll_dice << game.dice[s-49] end }
  player.refine(reroll_dice)
  puts "You have rolled #{game.dice.map {|d| d.num}.join(', ')}"
  score = -1
  score = player.score($stdin.gets.strip) until (score != -1)
  player.print_board
end
