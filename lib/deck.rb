require File.dirname(__FILE__) + '/game_constants.rb'
require File.dirname(__FILE__) + '/card.rb'

module Game
  EmptyDeck = Class.new(RuntimeError) 

  class Deck
    def initialize
      @cards_by_name = create_cards
    end

    def next_card
     index = rand(self.card_count)
     card_to_select =  remaining_cards[index]
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

    def create_cards
      cards = {}
      RANKS.each do |rank|
        SUITS.each do |suit|
          card = Card.new(rank, suit)
          cards[card.to_s] = card
        end
      end
      cards
    end
  end
end
