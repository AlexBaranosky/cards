require File.dirname(__FILE__) + '/../lib/card.rb'
require File.dirname(__FILE__) + '/../lib/sorted_cards.rb'
require File.dirname(__FILE__) + '/../lib/poker_cards.rb'
require File.dirname(__FILE__) + '/../lib/hand.rb'

module TestHelper

  def assert_invalid_hand_of_type(klass, *card_strings)
    assert klass.can_create_hand_from?(create_poker_cards(*card_strings)) != true
  end

  def create_cards(*card_strings)
    card_strings.each_with_object(Game::SortedCards.new) do |string, cards|
        cards << Game::Card.from_string(string)
    end
  end

  def create_poker_cards(*card_strings)
    Game::PokerCards.create(create_cards(*card_strings))
  end

  def two_pair_hand_from(*cards)
    cards = create_poker_cards(*cards)
    Game::TwoPair.create(cards)
  end

  def high_card_hand_from(*cards)
    cards = create_poker_cards(*cards)
    Game::HighCard.create(cards)
  end

  def pair_hand_from(*cards)
    cards = create_poker_cards(*cards)
    Game::Pair.create(cards)
  end

  def trip_hand_from(*cards)
    cards = create_poker_cards(*cards)
    Game::ThreeOfAKind.create(cards)
  end

  def straight_hand_from(*cards)
    cards = create_poker_cards(*cards)
    Game::Straight.create(cards)
  end

  def flush_hand_from(*cards)
    cards = create_poker_cards(*cards)
    Game::Flush.create(cards)
  end

  def full_house_hand_from(*cards)
    cards = create_poker_cards(*cards)
    Game::FullHouse.create(cards)
  end

  def quads_hand_from(*cards)
    cards = create_poker_cards(*cards)
    Game::FourOfAKind.create(cards)
  end

  def straight_flush_from(*cards)
    cards = create_poker_cards(*cards)
    Game::StraightFlush.create(cards)
  end
end
