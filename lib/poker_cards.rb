require File.dirname(__FILE__) + '/game_helpers.rb'
require File.dirname(__FILE__) + '/sorted_cards.rb'

module Game

  NotFiveCards = Class.new(ArgumentError)

  class PokerCards
  include Comparable
    include StraightHelpers

    def self.create(cards)
      raise NotFiveCards unless cards.size == 5
      groupings = GroupByCount.new(cards)
      self.new(cards, groupings)
    end

    def wins_by_high_card?(other_poker_cards)
      size.times do |index|
        if self[index] != other_poker_cards[index]
          return self[index] > other_poker_cards[index]
        end
      end
      false
    end

   #TODO: Could use inheritence to get rid of all these methods that delegate straight to @cards
    def <=>(other)
      @cards <=> other.cards
    end

    def size
      @cards.size
    end

    def high_card
      @cards.high_card
    end

    def ranks
      @cards.ranks
    end

    def [](index)
      @cards[index]
    end
    #################################################################################################

    def flush?
      @cards.suits.uniq.size == 1
    end

    def straight?
      return true if is_ace_to_five?(@cards)

      (@cards.size - 1).times do |index|
        return false unless in_order?(@cards[index], @cards[index+1])
      end
      return true
    end

    def five_card_combos
      @cards.five_card_combos.map { |combo| PokerCards.create(combo)}
    end

    def pairs
      @groupings.groups_of(2)
    end

    def high_pair
      pairs.first
    end

    def low_pair
      pairs.last
    end

    def pair_count
      pairs.size
    end

    def trips
      @groupings.groups_of(3)
    end

    def quads
      @groupings.groups_of(4)
    end

    private

    def initialize(cards, groupings)
      @cards = cards
      @groupings = groupings
    end
  end

  class GroupByCount
    def initialize(cards)
      @groupings = (0..4).map { SortedCards.new }
      cards.each_with_object(Hash.new(0)) do |card, counts|
        counts[card.rank] += 1
        add(card, counts[card.rank])
      end
    end

    def groups_of(count)
      @groupings[count].empty? ? nil : @groupings[count]
    end

    private

    def add(card, count)
      @groupings[count] << card
      @groupings[count - 1].delete_if { |c| c.rank == card.rank }
    end
  end
end
