require File.dirname(__FILE__) + '/../lib/hand.rb'

module Game
  class Hands
    HANDS_WORST_TO_BEST = [ Game::HighCard, Game::Pair, Game::TwoPair,
                            Game::ThreeOfAKind, Game::Straight, 
                            Game::Flush, Game::FullHouse, 
                            Game::FourOfAKind, Game::StraightFlush ].sort { |h1, h2| h2.rank <=> h1.rank }
    class << self
      def best_possible_hand_from(poker_aware_cards)
        possible_hands_from(poker_aware_cards).max
      end

      private

      def possible_hands_from(poker_aware_cards)
        poker_aware_cards.five_card_combos.map do |five_card_combo|
          hand_for(five_card_combo)
        end
      end

      def hand_for(poker_aware_cards)
        hand_class = HANDS_WORST_TO_BEST.find do |hand_class|
          hand_class.can_create_hand_from?(poker_aware_cards)
        end
        hand_class.create(poker_aware_cards)
      end
    end
  end
end
