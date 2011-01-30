require 'test/unit'
require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/../lib/sorted_cards.rb'

class SortedCardsTest < Test::Unit::TestCase
  include TestHelper

  def test_can_create_sorted_cards
    sorted_cards = create_cards("9 Spades", "9 Clubs", "6 Spades",
                                   "2 Spades", "2 Hearts")
    assert sorted_cards.cards
    assert_equal 5, sorted_cards.size
  end

  def test_should_return_ranks
    sorted_cards = create_cards("9 Spades", "9 Clubs", "6 Spades",
                                   "2 Spades", "2 Hearts")
    assert_equal [9,9,6,2,2], sorted_cards.ranks
  end

  def test_cards_should_be_sorted_descending
    sorted_cards = create_cards("3 Spades", "9 Clubs", "6 Spades",
                                   "A Spades", "2 Hearts")
    assert_equal ["A",9,6,3,2], sorted_cards.ranks
    assert_equal "A", sorted_cards.cards.first.rank
  end

  def test_sorted_cards_high_card
    sorted_cards = create_cards("3 Spades", "9 Clubs", "6 Spades",
                                   "K Spades", "2 Hearts")
    assert_equal "K", sorted_cards.high_card.rank
  end

  def test_should_return_suits
    sorted_cards = create_cards("9 Spades", "9 Clubs", "6 Spades",
                                   "2 Spades", "2 Hearts")
    assert_equal ["Spades","Clubs", "Spades", "Spades", "Hearts"], 
                  sorted_cards.suits
  end

  def test_should_keep_cards_in_order_after_appending
    sorted_cards = create_cards("2 Spades", "9 Clubs", "6 Spades",
                                   "3 Spades")
    ace = Game::Card.new("A", "Clubs")
    assert_equal "9 Clubs", sorted_cards.high_card.to_s
    sorted_cards << ace
    assert_equal "A Clubs", sorted_cards.high_card.to_s
  end
end
