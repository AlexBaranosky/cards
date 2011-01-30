require File.dirname(__FILE__) + '/straight_knowing.rb'
require File.dirname(__FILE__) + '/ranks.rb'

module Game
  class Card
    include Comparable

    attr_reader :suit, :rank

    def initialize(rank, suit)
      @suit = suit
      @rank = rank
    end

    def self.from_string(name)
      rank, suit = name.split(" ")
      rank = rank.to_i if rank < "A"
      Card.new(rank, suit)
    end

    def to_s
      "#{rank} #{suit}"
    end

    def <=>(card)
      Ranks.rank_index_of(self) <=> Ranks.rank_index_of(card)
    end
  end
end