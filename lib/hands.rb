require File.dirname(__FILE__) + '/../lib/hand.rb'

module Game
  class Hands
    HANDS_WORST_TO_BEST = [ Game::HighCard, Game::Pair, Game::TwoPair,
                            Game::ThreeOfAKind, Game::Straight, 
                            Game::Flush, Game::FullHouse, 
                            Game::FourOfAKind, Game::StraightFlush ].sort { |h1, h2| h2.rank <=> h1.rank }
    class << self
      def best_possible_hand_from(cards)
        possible_hands_from(cards).max
      end

      private

      def possible_hands_from(cards)
        cards.five_card_combos.map do |five_card_combo|
          hand_for(five_card_combo)
        end
      end

      def hand_for(cards)
        hand_class = HANDS_WORST_TO_BEST.find { |hand_class| hand_class.can_create_hand_from?(cards) }
        hand_class.create(cards)
      end
    end
  end
end
