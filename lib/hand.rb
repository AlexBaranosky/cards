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

    def high_card
      @poker_cards.high_card
    end

    def self.rank
      @rank
    end

    def <=>(other_hand)
      comparison = rank <=> other_hand.rank
      return compare_same_rank(other_hand) if comparison == 0
      comparison
    end

    def compare_same_rank(other_hand)
      return 0 if @poker_cards == other_hand.poker_cards
      beats_same_rank?(other_hand) ? 1 : -1
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
    def beats_same_rank?(other_hand)
      poker_cards.wins_by_high_card?(other_hand.poker_cards)
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
    def beats_same_rank?(other_hand)
      if high_pair == other_hand.high_pair
        return poker_cards.wins_by_high_card?(other_hand.poker_cards)
      end
      return high_pair > other_hand.high_pair
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
    def beats_same_rank?(other_hand)
      if high_pair == other_hand.high_pair
        if low_pair == other_hand.low_pair
          return poker_cards.wins_by_high_card?(other_hand.poker_cards)
        end
        return low_pair > other_hand.low_pair
      end
      return high_pair > other_hand.high_pair
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
    def beats_same_rank?(other_hand)
      if trips == other_hand.trips
        return poker_cards.wins_by_high_card?(other_hand.poker_cards)
      end
      return trips > other_hand.trips
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

    def beats_same_rank?(other_hand)
      poker_cards.wins_by_high_card?(other_hand.poker_cards)
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
    def beats_same_rank?(other_hand)
      if trips == other_hand.trips
        return high_pair > other_hand.high_pair
      else
        return trips > other_hand.trips
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
    def beats_same_rank?(other_hand)
      if self.quads == other_hand.quads
        return poker_cards.wins_by_high_card?(other_hand.poker_cards)
      end
      return self.quads > other_hand.quads
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
