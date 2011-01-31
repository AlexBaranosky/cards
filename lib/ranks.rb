module Game

  class Ranks
    RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]

    class << self
      def rank_index_of(card)
        RANKS.find_index(card.rank)
      end

      def in_order?(card, next_card)
        rank_index_of(card) - 1 == rank_index_of(next_card)
      end
    end
  end
end