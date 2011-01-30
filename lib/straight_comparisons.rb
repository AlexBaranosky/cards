require File.dirname(__FILE__) + '/game_helpers.rb'
module Game
  module StraightComparisons
    include StraightHelpers

    private
    def compare_same_rank(opponent)
      if is_ace_to_five?(poker_aware_cards)
        return false
      elsif is_ace_to_five?(opponent.poker_aware_cards)
        return true
      end
      return self.high_card > opponent.high_card
    end
  end
end
