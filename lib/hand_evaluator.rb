class HandEvaluator

  # Obtaining pair, 3 and four of a kind
  def same_card(hand, game)
    number = 0
    counts = Hash.new(0)

    hand.each do |element|
      counts[element[0]]+=1
    end
    counts.each do |key, value|
      if value%game == 0
        case game
        when 2
          number += value/2
        when 3
          number += 3
        when 4
          number+=7
        end
      end
    end
    return number
  end

  # Obtaining straight function
  def straight(hand)
    cards = Array.new()
    hand.each_with_index do |element, index|
      cards[index] = element[0]
      case cards[index]
      when "T"
        cards[index] = 10
      when "J"
        cards[index] = 11
      when "Q"
        cards[index] = 12
      when "K"
        cards[index] = 13
      when "A"
        cards[index] = 14
      end
    end

    cards = cards.map(&:to_i).sort.reverse
    switch = true
    aux = cards[0]
    for i in 1..4
      if cards[i] == (aux - 1) and switch
        aux = cards[i]
      else
        switch = false
      end
    end

    if switch
      return 4
    else
      return 0
    end
  end

  # Obtaining flush function
  def flush(hand)
    suit = hand[0][1]
    hand.each do |value|
      if value[1] != suit
        return 0
      end
    end
    return 5
  end

  # Obtaining Full House function
  def full_house(hand)
    if same_card(hand, 2) > 0 and same_card(hand, 3) > 0
      return 6
    end
    return 0
  end

  # Obtaining straight flush function
  def straight_flush(hand)
    if straight(hand) > 0 and flush(hand) > 0
      return 8
    end
    return 0
  end

  # Obtaining royal flush function
  def royal_flush(hand)
    aux = Array.new
    royal = ["A", "K", "Q", "J", "T"]

    hand.each_with_index do |card, index|
      aux[index] = card[0]
    end
    
    if flush(hand) > 0 and aux == royal
      return 9
    end
    return 0
  end

  # Obtaining higher card
  def kicker(hand)
    cards = Array.new()
    hand.each_with_index do |element, index|
      cards[index] = element[0]
      case cards[index]
      when "T"
        cards[index] = 10
      when "J"
        cards[index] = 11
      when "Q"
        cards[index] = 12
      when "K"
        cards[index] = 13
      when "A"
        cards[index] = 14
      end
    end

    cards = cards.map(&:to_i).sort.reverse
    kicker = cards[0]
    return kicker
  end

  # Stronger hand function
  def return_stronger_hand(left, right)
    first_hand_points = 0
    second_hand_points = 0
    right_hand = Array.new
    left_hand = Array.new
    # First hand
    if royal_flush(left) > 0
      first_hand_points = royal_flush(left)
    elsif  straight_flush(left) > 0
      first_hand_points = straight_flush(left)
    elsif same_card(left, 4) > 0
      first_hand_points = same_card(left, 4)
    elsif full_house(left) > 0
      first_hand_points = full_house(left)
    elsif flush(left) > 0
      first_hand_points = flush(left)
    elsif straight(left) > 0
      first_hand_points = flush(left)
    elsif same_card(left, 3) > 0
      first_hand_points = same_card(left, 3)
    elsif same_card(left, 2) > 0
      first_hand_points = same_card(left, 2)
    end

    # Second hand
    if royal_flush(right) > 0
      second_hand_points = royal_flush(right)
    elsif  straight_flush(right) > 0
      second_hand_points = straight_flush(right)
    elsif same_card(right, 4) > 0
      second_hand_points = same_card(right, 4)
    elsif full_house(right) > 0
      second_hand_points = full_house(right)
    elsif flush(right) > 0
      second_hand_points = flush(right)
    elsif straight(right) > 0
      second_hand_points = flush(right)
    elsif same_card(right, 3) > 0
      second_hand_points = same_card(right, 3)
    elsif same_card(right, 2) > 0
      second_hand_points = same_card(right, 2)
    end

    # Hand without suit
    left.each_with_index do |element, index|
      left_hand[index] = element[0]
    end

    right.each_with_index do |element, index|
      right_hand[index] = element[0]
    end

    left_hand = left_hand.map(&:to_i).sort.reverse
    right_hand = right_hand.map(&:to_i).sort.reverse
  
    if first_hand_points > second_hand_points
      return left
    elsif second_hand_points > first_hand_points
      return right
    end

    if left == right or right_hand == left_hand
      puts "Tie, both hands have the same hand"
      return left, right
    end
    
    if first_hand_points == second_hand_points
      if kicker(left) > kicker(right)
        return left
      elsif kicker(left) < kicker(right)
        return right
      end
    end


  end
end

# Main
hand_1 = %w(2D 2S AH QC 4C)
hand_2 = %w(9S TS JS QS KS)
print HandEvaluator.new.return_stronger_hand(hand_1, hand_2)