#!/usr/bin/ruby

require 'die.rb'
require 'player.rb'
require 'round.rb'

class YahtzeeGame
  def initialize(players = 1)
    @dice = Array.new(5) {Die.new}
    @no_of_players = players
    @curr_player_no = 0
    @players = Array.new(@no_of_players) { Player.new(self) }
    @rolls = 0
  end

  def roll(reroll_dice = [0,1,2,3,4])
    if (@rolls < 3)
      reroll_dice.map {|n| @dice[n] }.each do | die | die.roll end
      @rolls = @rolls + 1
    else
      raise "You've had 3 rolls - choose a category to score this turn"
    end
  end

  def end_turn
    @rolls = 0
    @curr_player_no = (@curr_player_no + 1) % @no_of_players
  end

  def curr_player
    @players[@curr_player_no]
  end

  def curr_player_no
    @curr_player_no + 1
  end

  def dice
    @dice.map {|d| d.num}
  end

  def over?
    @players.any? {|p| p.finished?}
  end
end

key_move_mappings = {"1" => :ones, "2" => :twos, "3" => :threes,
    "4" => :fours, "5" => :fives, "6" => :sixes,
    "s" => :small_straight, "l" => :large_straight,
    "t" => :three_of_a_kind, "f" => :four_of_a_kind,
    "h" => :full_house, "y" => :yahtzee, "?" => :chance};

game = YahtzeeGame.new
until (game.over?)
  puts "Player #{game.curr_player_no}'s turn"
  player = game.curr_player
  player.start_turn
  puts "Your first roll is #{game.dice.join(', ')}.\nEnter the numbers of the dice you want to reroll (e.g. \"12345\" for all dice)"
  command = $stdin.gets
  reroll_dice = Array.new
  command.each_byte {|s| if (s >= 49 && s <= 54) then reroll_dice << s-49 end }
  player.refine(reroll_dice)
  puts "Your second roll is #{game.dice.join(', ')}.\nEnter the numbers of the dice you want to reroll (e.g. \"12345\" for all dice)"
  command = $stdin.gets
  reroll_dice.clear
  command.each_byte {|s| if (s >= 49 && s <= 54) then reroll_dice << s-49 end }
  player.refine(reroll_dice)
  puts "Your final roll is #{game.dice.join(', ')}.\nEnter your move - one of: 123456tfslh?y"
  score = -1
  score = player.score(key_move_mappings[$stdin.gets.strip]) until (score != -1)
  puts "You scored #{score} in that move"
  player.print_board
end
puts "The winner is player #{game.curr_player_no} with a score of #{player.total_score}"
