module Game
  module StraightKnowing
    def is_ace_to_five?(cards)
      cards.ranks == ["A", 5, 4, 3, 2]
    end
  end
end
