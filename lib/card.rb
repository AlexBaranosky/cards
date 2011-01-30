require File.dirname(__FILE__) + '/game_constants.rb'
require File.dirname(__FILE__) + '/game_helpers.rb'

module Game
  class Card
    include CardRanking
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
      rank_index_of(self) <=> rank_index_of(card)
    end
  end
end