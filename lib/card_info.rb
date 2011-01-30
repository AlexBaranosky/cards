require File.dirname(__FILE__) + '/game_helpers.rb'
require File.dirname(__FILE__) + '/cards.rb'

module Game

  NotFiveCards = Class.new(ArgumentError)

  class CardInfo
    extend StraightHelpers
    extend FlushHelpers

    def initialize(groupings, is_flush, is_straight)
      @groupings = groupings
      @is_flush = is_flush
      @is_straight = is_straight
    end

    def flush?
      @is_flush
    end

    def straight?
      @is_straight
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

    def self.info_for(cards)
      raise NotFiveCards unless cards.size == 5
      groupings = Groupings.new(cards)
      is_flush = all_same_suit?(cards)
      is_straight = is_a_straight?(cards)
      self.new(groupings, is_flush, is_straight)
    end
  end

  class Groupings
    def initialize(cards)
      @groupings = (0..4).map { Cards.new }
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
