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

# print_hand
# prints the hand of the player
def print_hand hand
  p hand
  p hand_value( hand )
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
    value_str = card[0..-2]

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
  hand.count{ | card | card[0..-2] == 'A' }.times do
    #puts "here"
    break if result <= 21
    #puts "Aces, biatch"
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

  puts "Player score: #{ hand_value(player_hand) }"

  # ask if wants to hit
  print "Hit or Stand (H/S): "
  choice = gets.chomp.downcase

  # deal if yes
  deal_card( deck, player_hand, "Player" ) if choice == "h"

end while choice == "h" && hand_value(player_hand) < 21

puts "Player score: #{ hand_value(player_hand) }\n"
abort( "Bust! You lose..." ) if hand_value( player_hand ) > 21

# Deal to dealer
# TODO: if player hand > 21, then bust instead of deal to dealer
2.times do
  deal_card( deck, dealer_hand, "Dealer" )
end



# deal cards to the dealer
while hand_value( dealer_hand ) < 17
  deal_card( deck, dealer_hand, "Dealer")
end

puts "Dealer score: #{ hand_value(dealer_hand) }\n"

puts "Dealer stands"


# evaluate results

if hand_value( dealer_hand ) > 21
  puts "You win, the dealer went over"
elsif hand_value( player_hand ) > hand_value( dealer_hand )
  puts "You win, the dealer was too low"
else
  puts "You lose, don't gamble next time"
end


