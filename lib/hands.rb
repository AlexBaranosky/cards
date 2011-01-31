require File.dirname(__FILE__) + '/../lib/hand.rb'

module Game
  class Hands
    HANDS = [Game::HighCard, Game::Pair, Game::TwoPair,
             Game::ThreeOfAKind, Game::Straight,
             Game::Flush, Game::FullHouse, 
             Game::FourOfAKind, Game::StraightFlush]

    class << self
      def best_possible_hand_from(poker_cards)
        possible_hands_from(poker_cards).max
      end

      private

      def possible_hands_from(poker_cards)
        poker_cards.five_card_combos.map do |five_card_combo|
          hand_for(five_card_combo)
        end
      end

      def hand_for(poker_cards)
        hand_class = HANDS.find do |hand_class|
          hand_class.can_create_hand_from?(poker_cards)
        end
        hand_class.create(poker_cards)
      end
    end
  end
end
