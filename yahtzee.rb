#!/usr/bin/ruby

require 'die.rb'
require 'player.rb'
require 'round.rb'

class YahtzeeGame
  def initialize
    @dice = [Die.new, Die.new, Die.new, Die.new, Die.new]
  end

  def roll(reroll_dice = @dice)
    reroll_dice.each do | die | die.roll end
  end

  attr_reader :dice
end


game = YahtzeeGame.new
player = Player.new(game)
while (true)
  player.start_turn
  puts "Your first roll is #{game.dice.map {|d| d.num}.join(', ')}.\nEnter the numbers of the dice you want to reroll (e.g. \"12345\" for all dice)"
  command = $stdin.gets
  reroll_dice = Array.new
  command.each_byte {|s| if (s >= 49 && s <= 54) then reroll_dice << game.dice[s-49] end }
  player.refine(reroll_dice)
  puts "Your second roll is #{game.dice.map {|d| d.num}.join(', ')}.\nEnter the numbers of the dice you want to reroll (e.g. \"12345\" for all dice)"
  command = $stdin.gets
  reroll_dice.clear
  command.each_byte {|s| if (s >= 49 && s <= 54) then reroll_dice << game.dice[s-49] end }
  player.refine(reroll_dice)
  puts "Your final roll is #{game.dice.map {|d| d.num}.join(', ')}.\nEnter your move - one of: 123456tfslh?y"
  score = -1
  score = player.score($stdin.gets.strip) until (score != -1)
  player.print_board
end
