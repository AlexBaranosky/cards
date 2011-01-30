module Game

  module StraightHelpers
    def in_order?(card, next_card)
      Ranks.rank_index_of(card) - 1 == Ranks.rank_index_of(next_card)
    end

    def is_ace_to_five?(cards)
      cards.ranks == ["A", 5, 4, 3, 2]
    end
  end
end
