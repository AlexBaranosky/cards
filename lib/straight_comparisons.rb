require File.dirname(__FILE__) + '/straight_knowing.rb'
module Game
  module StraightComparisons
    include StraightKnowing

    private

    def beats_same_rank?(other_hand)
      if is_ace_to_five?(poker_cards)
        return false
      elsif is_ace_to_five?(other_hand.poker_cards)
        return true
      end
      return self.poker_cards.high_card > other_hand.poker_cards.high_card
    end
  end
end
