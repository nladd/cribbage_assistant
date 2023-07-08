

DECK = {'1C' => 0,'2C' => 1,'3C' => 2,'4C' => 3,'5C' => 4,'6C' => 5,'7C' => 6,'8C' => 7,'9C' => 8,'10C' => 9,'11C' => 10,'12C' => 11,'13C' => 12,
        '1D' => 13,'2D' => 14,'3D' => 15,'4D' => 16,'5D' => 17,'6D' => 18,'7D' => 19,'8D' => 20,'9D' => 21,'10D' => 22,'11D' => 23,'12D' => 24,'13D' => 25,
        '1H' => 26,'2H' => 27,'3H' => 28,'4H' => 29,'5H' => 30,'6H' => 31,'7H' => 32,'8H' => 33,'9H' => 34,'10H' => 35,'11H' => 36,'12H' => 37,'13H' => 38,
        '1S' => 39,'2S' => 40,'3S' => 41,'4S' => 42,'5S' => 43,'6S' => 44,'7S' => 45,'8S' => 46,'9S' => 47,'10S' => 48,'11S' => 49,'12S' => 50,'13S' => 51}

def findBestHand(dealt_hand)
  puts "Dealt hand: #{dealt_hand}"

  max_points = 0
  best_hand = []
  #(0..4).each do |discard_1|
    #((discard_1+1)..5).each do |discard_2|
      #hand = dealt_hand - [dealt_hand[discard_1], dealt_hand[discard_2]]
  dealt_hand.combination(4).each do |hand|
    points = calc_point_value(hand)
    if points > max_points
      max_points = points
      best_hand = hand
    end
  end
    #end
  #end


  puts "The best hand is #{best_hand.sort} and is worth #{max_points} points"

  return best_hand
end


def calc_point_value(hand)

  points = 0
  points += calc_pair_points(hand)
#  puts calc_pair_points(hand)
  points += calc_run_points(hand)
#  puts calc_run_points(hand)
  points += calc_flush_points(hand)
#  puts calc_flush_points(hand)
  points += calc_fifteen_points(hand)
#  puts calc_fifteen_points(hand)


  points
end

def calc_pair_points(hand)
  pair_points = 0
  (0..2).each do |card_1|
    ((card_1+1)..3).each do |card_2|
      pair_points += 2 if DECK[hand[card_1]] % 13 == DECK[hand[card_2]] % 13
    end
  end

  pair_points
end

def calc_run_points(hand)

  run_points = 0
  # get the number representation of each card in our hand so that we can then sort it
#  deck_hand = deck_hand(hand)
#  deck_hand = deck_hand.map{|c| c % 13}.sort
#
#  # A run must be at least 3 cards so now that we have a sorted hand, a run has to start at either position 0 or postion 1
#  # if a run starts at position 0 we can have a three or four card run, if it start at position 1 then we can only have a 3
#  # card run
#  # Take the modulo 13 of each card and check that it is 1 larger than the previous card meaning the cards are in sequential order
#  # need to check the edge case of king/ace, because a run on Q, K, A is not valid
#
#  if deck_hand[1] % 13 == (deck_hand[0] % 13 + 1) && deck_hand[2] % 13 == (deck_hand[1] % 13 + 1)
#    # we have at least a three card run, check if it's a four card run
#    if deck_hand[3] % 13 == (deck_hand[2] % 13 + 1)
#      run_points = 4
#    else
#      run_points = 3
#    end
#  elsif deck_hand[1] % 13 == (deck_hand[0] % 13 + 1) && deck_hand[2] % 13 == (deck_hand[1] % 13 + 1)
#    run_points = 3
#  end

  deck_hand = hand_numbers(hand).sort
  if deck_hand[1] == deck_hand[0] + 1 && deck_hand[2] == deck_hand[1] + 1 && deck_hand[3] == deck_hand[2] + 1
    run_points = 4
  else
    deck_hand.combination(3).each do |combo|
      if combo[1] == combo[0] + 1 && combo[2] == combo[1] + 1
        run_points += 3
      end
    end
  end

  run_points
end

def calc_flush_points(hand)
  # a flush has to have all four cards be the same suit, suit is determined be the last characted of each card string so if the last
  # character is the same for all 4 cards, we have a flush, otherwise we don't
  if hand[0].chars.last == hand[1].chars.last && hand[1].chars.last == hand[2].chars.last && hand[2].chars.last == hand[3].chars.last
    4
  else
    0
  end

end

def calc_fifteen_points(hand)
  fifteen_points = 0

  #(2..4).each do |n|
  #  deck_hand(hand).combination(n).each do |combo|
  #    fifteen_points += 2 if combo.sum == 15
  #  end
  #end

  (0..2).each do |card_1|
    ((card_1+1)..3).each do |card_2|
      if card_value(hand[card_1]) + card_value(hand[card_2]) == 15
        fifteen_points += 2
      elsif card_value(hand[card_1]) + card_value(hand[card_2]) < 15
        ((card_2+1)..3).each do |card_3|
          if card_value(hand[card_1]) + card_value(hand[card_2]) + card_value(hand[card_3]) == 15
            fifteen_points += 2
          elsif card_value(hand[card_1]) + card_value(hand[card_2]) + card_value(hand[card_3]) < 15
            ((card_3+1)..3).each do |card_4|
              fifteen_points +=2 if card_value(hand[card_1]) + card_value(hand[card_2]) + card_value(hand[card_3]) + card_value(hand[card_4]) == 15
            end
          end
        end
      end
    end
  end

  fifteen_points
end

def hand_numbers(hand)
  hand.map {|c| c.chop.to_i }
end

def deck_hand(hand)
  [DECK[hand[0]], DECK[hand[1]], DECK[hand[2]], DECK[hand[3]]]
end

def card_value(card)
  val = DECK[card] % 13 + 1
  val > 10 ? 10 : val
end


findBestHand(['7S', '5C', '5H', '10S', '1C','10D'])
puts
findBestHand(['7C', '8H', '8C', '9D', '1C','10D'])
puts
findBestHand(['7C', '8H', '8C', '9C', '1C','10C'])
puts
findBestHand(['1C', '4H', '12C', '13C', '11D','8C'])
puts
findBestHand(['1C', '4C', '12C', '13C', '11D','8C'])
puts
findBestHand(['4H', '4C', '4D', '4S', '11D','8C'])
puts
findBestHand(['7H', '8C', '8D', '9S', '8H','9H'])
puts
findBestHand(['1S', '13S', '12D', '9S', '5H','9H'])
puts
findBestHand(['1S', '13S', '12D', '9S', '5H','2H'])
puts
#findBestHand(['7S', '7C', '8H', '8S', '9C','6D'])
puts
#findBestHand(['1S', '2S', '6D', '11S', '13H','10H'])
puts
#findBestHand(['6S', '9S', '10D', '5S', '7H','8H'])
puts
#findBestHand(["10D", "5S", "6S", "7H", "8H", "9S"])
puts
#findBestHand(['5S', '6S', '7S', '8S', '9S', '10S'])
puts
#findBestHand(['5S', '6S', '7D', '8S', '9H','10H'])

