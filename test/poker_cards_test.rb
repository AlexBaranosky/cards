require 'test/unit'
require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/../lib/poker_cards.rb'

class PokerCardsTest < Test::Unit::TestCase
  include TestHelper

  def test_should_error_when_given_too_many_cards
    assert_raise Game::NotFiveCards do
      poker_cards_for("3 Spades", "2 Hearts", "5 Clubs", "A Diamonds", "K Diamonds", "5 Hearts")
    end
  end

  def test_should_error_when_given_too_few_cards
    assert_raise Game::NotFiveCards do
      poker_cards_for("5 Clubs", "A Diamonds", "K Diamonds", "5 Hearts")
    end
  end

  def test_should_have_no_pairs
    poker_cards = poker_cards_for("3 Spades", "2 Hearts", "5 Clubs", "A Diamonds", "K Diamonds")
    assert_nil poker_cards.pairs
  end

  def test_high_and_low_pairs_should_be_same_with_single_pair
    poker_cards = poker_cards_for("3 Spades", "5 Hearts", "5 Clubs", "A Diamonds", "K Diamonds")
    assert_equal 5, poker_cards.high_pair.rank
    assert_equal 5, poker_cards.low_pair.rank
  end

  def test_should_have_two_pairs
    poker_cards = poker_cards_for("3 Spades", "A Hearts", "5 Clubs", "A Diamonds", "3 Diamonds")
    assert_equal 2, poker_cards.pair_count
    assert_equal "A", poker_cards.high_pair.rank
    assert_equal 3, poker_cards.low_pair.rank
  end

  def test_should_have_trips_and_pair
    poker_cards = poker_cards_for("3 Spades", "A Hearts", "A Clubs", "A Diamonds", "3 Diamonds")
    assert_equal 1, poker_cards.pair_count
    assert_equal 1, poker_cards.trips.size
    assert_equal "A", poker_cards.trips.first.rank
  end

  def test_should_have_quads
    poker_cards = poker_cards_for("3 Spades", "A Hearts", "A Clubs", "A Diamonds", "A Spades")
    assert_equal 1, poker_cards.quads.size
    assert_equal "A", poker_cards.quads.first.rank
  end

  def test_should_not_count_quads_as_pair_or_trips
    poker_cards = poker_cards_for("3 Spades", "A Hearts", "A Clubs", "A Diamonds", "A Spades")
    assert_nil poker_cards.trips
    assert_nil poker_cards.pairs
  end

  def test_should_not_count_trips_as_pair
    poker_cards = poker_cards_for("3 Spades", "A Hearts", "A Clubs", "Q Diamonds", "A Spades")
    assert_nil poker_cards.pairs
  end

  def test_should_be_a_flush
    poker_cards = poker_cards_for("3 Spades", "2 Spades", "5 Spades", "A Spades", "K Spades")
    assert poker_cards.flush?
  end

  def test_should_not_be_a_flush
    poker_cards = poker_cards_for("3 Spades", "2 Spades", "5 Spades", "A hearts", "K Spades")
    assert !poker_cards.flush?
  end

  def test_should_not_be_a_straight
    poker_cards = poker_cards_for("10 Spades", "J Diamonds", "2 Spades", "9 hearts", "K Spades")
    assert !poker_cards.straight?
    poker_cards = poker_cards_for("7 Spades", "8 Spades", "2 Spades", "10 Spades", "9 Spades")
    assert !poker_cards.straight?
  end

  def test_should_be_a_straight
    poker_cards = poker_cards_for("10 Spades", "J Diamonds", "Q Spades", "9 hearts", "K Spades")
    assert poker_cards.straight?
  end

  def test_ace_to_five_straight
    poker_cards = poker_cards_for("2 Spades", "3 Diamonds", "4 Spades", "5 hearts", "A Spades")
    assert poker_cards.straight?
  end

  def poker_cards_for(*cards)
    cards = create_cards(*cards)
    Game::PokerCards.create(cards)
  end
end
