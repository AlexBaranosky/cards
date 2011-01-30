module Game

  class Ranks
    RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]

    def self.rank_index_of(card)
      RANKS.find_index(card.rank)
    end
  end
end