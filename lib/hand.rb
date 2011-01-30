require File.dirname(__FILE__) + '/straight_comparisons.rb'
require File.dirname(__FILE__) + '/poker_aware_cards.rb'

module Game
  class Hand
    include Comparable
    attr_reader :rank, :poker_aware_cards

    CannotCreateHand = Class.new(Exception)

    def self.create(cards)
      raise CannotCreateHand unless can_create_hand_from?(cards)
      poker_aware_cards = Game::PokerAwareCards.create(cards)
      self.new(poker_aware_cards)
    end

    def self.can_create_hand_from?(cards)
      poker_aware_cards = Game::PokerAwareCards.create(cards)
      valid?(poker_aware_cards)
    end

    def initialize(poker_aware_cards)
      @poker_aware_cards = poker_aware_cards
    end

    def ranks
      poker_aware_cards.ranks
    end

    def high_card
      poker_aware_cards.high_card
    end

    def self.rank
      @rank
    end

    def <=>(opponent)
      return 1 if beats?(opponent)
      return -1 if opponent.beats?(self)
      0
    end

    protected

    def beats?(opponent)
      return compare_same_rank(opponent) if rank == opponent.rank
      rank > opponent.rank
    end

    def high_pair
      poker_aware_cards.high_pair
    end

    def low_pair
      poker_aware_cards.low_pair
    end

    private

    def wins_by_high_card?(opponent)
      poker_aware_cards.size.times do |index|
        if poker_aware_cards[index] != opponent.poker_aware_cards[index]
          return poker_aware_cards[index] > opponent.poker_aware_cards[index]
        end
      end
      false
    end
  end

  class HighCard < Hand
    def initialize(poker_aware_cards)
      @rank = 0
      super
    end

    def self.valid?(poker_aware_cards)
      !(poker_aware_cards.pairs || poker_aware_cards.trips || poker_aware_cards.quads || poker_aware_cards.flush? || poker_aware_cards.straight?)
    end

    private
    def compare_same_rank(opponent)
      wins_by_high_card?(opponent)
    end
  end

  class Pair < Hand            
    def initialize(poker_aware_cards)
      @rank = 1
      super
    end

    def self.valid?(poker_aware_cards)
      poker_aware_cards.pairs && poker_aware_cards.pair_count == 1 && !poker_aware_cards.trips
    end

    private
    def compare_same_rank(opponent)
      if high_pair == opponent.high_pair
        return wins_by_high_card?(opponent)
      end
      return high_pair > opponent.high_pair
    end
  end

  class TwoPair < Hand

    def initialize(poker_aware_cards)
      @rank = 2
      super
    end

    def self.valid?(poker_aware_cards)
      poker_aware_cards.pairs && poker_aware_cards.pair_count == 2
    end


    private
    def compare_same_rank(opponent)
      if high_pair == opponent.high_pair
        if low_pair == opponent.low_pair
          return wins_by_high_card?(opponent)
        end
        return low_pair > opponent.low_pair
      end
      return high_pair > opponent.high_pair
    end
  end

  class ThreeOfAKind < Hand
    def initialize(poker_aware_cards)
      @rank = 3
      super
    end

    def self.valid?(poker_aware_cards)
      poker_aware_cards.trips && !poker_aware_cards.pairs
    end

    protected
    def trips
      poker_aware_cards.trips.first
    end

    private
    def compare_same_rank(opponent)
      if trips == opponent.trips
        return wins_by_high_card?(opponent)
      end
      return trips > opponent.trips
    end
  end

  class Straight < Hand
    include Game::StraightComparisons

    def initialize(poker_aware_cards)
      @rank = 4
      super
    end

    def self.valid?(poker_aware_cards)
      poker_aware_cards.straight? && !poker_aware_cards.flush?
    end
  end

  class Flush < Hand
    def initialize(poker_aware_cards)
      @rank = 5
      super
    end

    def self.valid?(poker_aware_cards)
      poker_aware_cards.flush? && !poker_aware_cards.straight?
    end

    def compare_same_rank(opponent)
      wins_by_high_card?(opponent)
    end
  end

  class FullHouse < Hand

    def initialize(poker_aware_cards)
      @rank = 6
      super
    end

    def self.valid?(poker_aware_cards)
      poker_aware_cards.trips && poker_aware_cards.pairs
    end

    protected
    def trips
      poker_aware_cards.trips.first
    end


    private
    def compare_same_rank(opponent)
      if trips == opponent.trips
        return high_pair > opponent.high_pair
      else
        return trips > opponent.trips
      end
    end
  end

  class FourOfAKind < Hand
    def initialize(poker_aware_cards)
      @rank = 7
      super
    end

    def self.valid?(poker_aware_cards)
      poker_aware_cards.quads
    end

    protected
    def quads
      poker_aware_cards.quads.first
    end

    private
    def compare_same_rank(opponent)
      if self.quads == opponent.quads
        return wins_by_high_card?(opponent)
      end
      return self.quads > opponent.quads
    end
  end

  class StraightFlush < Hand
    include Game::StraightComparisons

    def initialize(poker_aware_cards)
      @rank = 8
      super
    end

    def self.valid?(poker_aware_cards)
      poker_aware_cards.flush? && poker_aware_cards.straight?
    end
  end
end
