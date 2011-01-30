require File.dirname(__FILE__) + '/straight_comparisons.rb'
require File.dirname(__FILE__) + '/poker_cards.rb'

module Game
  class Hand
    include Comparable
    attr_reader :rank, :poker_cards

    CannotCreateHand = Class.new(Exception)

    def self.create(poker_cards)
      raise CannotCreateHand unless can_create_hand_from?(poker_cards)
      self.new(poker_cards)
    end

    def self.can_create_hand_from?(poker_cards)
      valid?(poker_cards)
    end

    def initialize(poker_cards)
      @poker_cards = poker_cards
    end

    def ranks
      @poker_cards.ranks
    end

    def high_card
      @poker_cards.high_card
    end

    def self.rank
      @rank
    end

    def <=>(opponent)
      comparison = rank <=> opponent.rank
      return compare_same_rank(opponent) if comparison == 0
      comparison
    end

    def compare_same_rank(opponent)
      return 0 if @poker_cards == opponent.poker_cards
      beats_same_rank?(opponent) ? 1 : -1
    end

    protected

    def high_pair
      poker_cards.high_pair
    end

    def low_pair
      poker_cards.low_pair
    end
  end

  class HighCard < Hand
    def initialize(poker_cards)
      @rank = 0
      super
    end

    def self.valid?(poker_cards)
      !(poker_cards.pairs || poker_cards.trips || poker_cards.quads || poker_cards.flush? || poker_cards.straight?)
    end

    private
    def beats_same_rank?(opponent)
      poker_cards.wins_by_high_card?(opponent)
    end
  end

  class Pair < Hand            
    def initialize(poker_cards)
      @rank = 1
      super
    end

    def self.valid?(poker_cards)
      poker_cards.pairs && poker_cards.pair_count == 1 && !poker_cards.trips
    end

    private
    def beats_same_rank?(opponent)
      if high_pair == opponent.high_pair
        return poker_cards.wins_by_high_card?(opponent)
      end
      return high_pair > opponent.high_pair
    end
  end

  class TwoPair < Hand

    def initialize(poker_cards)
      @rank = 2
      super
    end

    def self.valid?(poker_cards)
      poker_cards.pairs && poker_cards.pair_count == 2
    end


    private
    def beats_same_rank?(opponent)
      if high_pair == opponent.high_pair
        if low_pair == opponent.low_pair
          return poker_cards.wins_by_high_card?(opponent)
        end
        return low_pair > opponent.low_pair
      end
      return high_pair > opponent.high_pair
    end
  end

  class ThreeOfAKind < Hand
    def initialize(poker_cards)
      @rank = 3
      super
    end

    def self.valid?(poker_cards)
      poker_cards.trips && !poker_cards.pairs
    end

    protected
    def trips
      poker_cards.trips.first
    end

    private
    def beats_same_rank?(opponent)
      if trips == opponent.trips
        return poker_cards.wins_by_high_card?(opponent)
      end
      return trips > opponent.trips
    end
  end

  class Straight < Hand
    include Game::StraightComparisons

    def initialize(poker_cards)
      @rank = 4
      super
    end

    def self.valid?(poker_cards)
      poker_cards.straight? && !poker_cards.flush?
    end
  end

  class Flush < Hand
    def initialize(poker_cards)
      @rank = 5
      super
    end

    def self.valid?(poker_cards)
      poker_cards.flush? && !poker_cards.straight?
    end

    def beats_same_rank?(opponent)
      poker_cards.wins_by_high_card?(opponent)
    end
  end

  class FullHouse < Hand

    def initialize(poker_cards)
      @rank = 6
      super
    end

    def self.valid?(poker_cards)
      poker_cards.trips && poker_cards.pairs
    end

    protected
    def trips
      poker_cards.trips.first
    end


    private
    def beats_same_rank?(opponent)
      if trips == opponent.trips
        return high_pair > opponent.high_pair
      else
        return trips > opponent.trips
      end
    end
  end

  class FourOfAKind < Hand
    def initialize(poker_cards)
      @rank = 7
      super
    end

    def self.valid?(poker_cards)
      poker_cards.quads
    end

    protected
    def quads
      poker_cards.quads.first
    end

    private
    def beats_same_rank?(opponent)
      if self.quads == opponent.quads
        return poker_cards.wins_by_high_card?(opponent)
      end
      return self.quads > opponent.quads
    end
  end

  class StraightFlush < Hand
    include Game::StraightComparisons

    def initialize(poker_cards)
      @rank = 8
      super
    end

    def self.valid?(poker_cards)
      poker_cards.flush? && poker_cards.straight?
    end
  end
end
