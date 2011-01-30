require File.dirname(__FILE__) + '/card.rb'
require File.dirname(__FILE__) + '/ranks.rb'
require File.dirname(__FILE__) + '/suits.rb'

module Game
  EmptyDeck = Class.new(RuntimeError) 

  class Deck
    def initialize
      @cards_by_name = one_of_each_of_the_52_cards
    end

    def next_card
     index = rand(card_count)
     card_to_select = remaining_cards[index]
     select_card(card_to_select.to_s)
    end

    def select_card(id)
      raise EmptyDeck unless card_count > 0
      @cards_by_name.delete(id)
    end

    def card_count
      @cards_by_name.size
    end

    def remaining_cards
      @cards_by_name.values
    end

    private

    def one_of_each_of_the_52_cards
      cards = {}
      Ranks::RANKS.each do |rank|
        Suits::SUITS.each do |suit|
          card = Card.new(rank, suit)
          cards[card.to_s] = card
        end
      end
      cards
    end
  end
end
