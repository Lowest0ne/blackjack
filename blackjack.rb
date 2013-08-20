#!/usr/bin/env ruby
# encoding: UTF-8

SUITS  = ['♠', '♣', '♥', '♦']
VALUES = ( 2..10 ).to_a.map{ |n| n.to_s }.concat( ['J', 'Q', 'K', 'A'] )

# build_deck
# returns a shuffled array of 52 cards
def build_deck
  deck =[]

  SUITS.each do |suit|
    VALUES.each do |value|
      deck << ( value + suit )
    end
  end

  deck.shuffle
end

# print_value
# prints the value of given hand and player name
def print_value hand, who
  puts "#{ who } score: #{ hand_value(hand) }\n\n"
end

# deal_card
# gives a card to the player
def deal_card deck, hand, who
  card = deck.pop
  puts "#{ who } was dealt #{ card }"
  hand << card
end

# hand_value
# returns the value of the hand
def hand_value hand
  result = 0
  hand.each do | card |
    value_str = card.chop

    case value_str
    when "2".."10"
      result += value_str.to_i
    when "A"
      result += 11
    else
      result += 10
    end

  end

  # handle aces being 11 or 1
  hand.count{ | card | card.chop == 'A' }.times do
    break if result <= 21
    result -= 10
  end

  result
end

# Welcome
puts "Welcome to Blackjack\n\n"

# variable to hold the deck
deck = build_deck

# variables to hold player and dealer hands
player_hand = []
dealer_hand = []

# Deals two cards to player
2.times do
  deal_card( deck, player_hand, "Player" )
end


# deal cards to the player
begin

  print_value( player_hand, "Player" )

  # ask if wants to hit
  print "Hit or Stand (H/S): "
  choice = gets.chomp.downcase
  puts "\n"

  # deal if yes
  deal_card( deck, player_hand, "Player" ) if choice == "h"

end while choice == "h" && hand_value(player_hand) < 21

print_value( player_hand, "Player" )

# leave game if player bust
abort( "Bust! You lose..." ) if hand_value( player_hand ) > 21

# Deal to dealer
2.times do
  deal_card( deck, dealer_hand, "Dealer" )
end



# deal cards to the dealer
while hand_value( dealer_hand ) < 17
  deal_card( deck, dealer_hand, "Dealer")
end

print_value( dealer_hand, "Dealer" )

puts "Dealer stands\n\n"


# evaluate results
# note that player hand has been evalutated as non-bust already

if hand_value( dealer_hand ) > 21
  puts "You win, the dealer went over"
elsif hand_value( player_hand ) > hand_value( dealer_hand )
  puts "You win, the dealer was too low"
else
  puts "You lose, don't gamble next time"
end


