class Player
  def initialize(game)
    @game = game
    @round = Round.new
  end

  def start_turn
    @game.roll
  end

  def refine(reroll_dice)
    @game.roll(reroll_dice)
  end

  def total_score
    @round.grand_total
  end

  def score(move)
    if (move.nil? || !@round.score(move).nil?)
      -1
    else
      @game.end_turn
      @round.make_move(move, @game.dice)
    end
  end

  def print_board
    @round.print
  end

  def finished?
    @round.complete?
  end
end
