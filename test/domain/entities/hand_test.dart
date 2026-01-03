import 'package:flutter_test/flutter_test.dart';
import 'package:suddendeath31/domain/entities/card.dart';
import 'package:suddendeath31/domain/entities/hand.dart';

void main() {
  group('Hand Scoring Tests', () {
    test('should calculate score as highest single-suit total', () {
      // Hand with mixed suits: 10♥, 5♥, 3♣ = 15 hearts
      final hand = Hand([
        const Card(suit: Suit.hearts, rank: Rank.ten),
        const Card(suit: Suit.hearts, rank: Rank.five),
        const Card(suit: Suit.clubs, rank: Rank.three),
      ]);
      
      expect(hand.score, 15);
      expect(hand.scoringSuit, Suit.hearts);
    });

    test('should identify 31 (three cards same suit totaling 31)', () {
      // Ace(11) + King(10) + Queen(10) = 31
      final hand = Hand([
        const Card(suit: Suit.spades, rank: Rank.ace),
        const Card(suit: Suit.spades, rank: Rank.king),
        const Card(suit: Suit.spades, rank: Rank.queen),
      ]);
      
      expect(hand.is31, true);
      expect(hand.hasInstantWin, true);
    });

    test('should identify Blitz (three of a kind)', () {
      final hand = Hand([
        const Card(suit: Suit.hearts, rank: Rank.seven),
        const Card(suit: Suit.diamonds, rank: Rank.seven),
        const Card(suit: Suit.clubs, rank: Rank.seven),
      ]);
      
      expect(hand.isBlitz, true);
      expect(hand.hasInstantWin, true);
    });

    test('should not identify 31 if different suits', () {
      final hand = Hand([
        const Card(suit: Suit.hearts, rank: Rank.ace),
        const Card(suit: Suit.diamonds, rank: Rank.king),
        const Card(suit: Suit.spades, rank: Rank.queen),
      ]);
      
      expect(hand.is31, false);
    });

    test('should not identify Blitz if different ranks', () {
      final hand = Hand([
        const Card(suit: Suit.hearts, rank: Rank.seven),
        const Card(suit: Suit.hearts, rank: Rank.eight),
        const Card(suit: Suit.hearts, rank: Rank.nine),
      ]);
      
      expect(hand.isBlitz, false);
    });

    test('should return scoring cards sorted by rank', () {
      final hand = Hand([
        const Card(suit: Suit.hearts, rank: Rank.five),
        const Card(suit: Suit.hearts, rank: Rank.king),
        const Card(suit: Suit.hearts, rank: Rank.two),
      ]);
      
      final scoringCards = hand.scoringCards;
      expect(scoringCards.length, 3);
      expect(scoringCards[0].rank, Rank.king); // Highest
      expect(scoringCards[1].rank, Rank.five);
      expect(scoringCards[2].rank, Rank.two); // Lowest
    });
  });

  group('Hand Manipulation Tests', () {
    test('should add card to hand', () {
      final hand = Hand.empty();
      const card = Card(suit: Suit.hearts, rank: Rank.ace);
      
      final newHand = hand.addCard(card);
      
      expect(newHand.size, 1);
      expect(newHand.cards.first, card);
    });

    test('should remove card from hand', () {
      const card1 = Card(suit: Suit.hearts, rank: Rank.ace);
      const card2 = Card(suit: Suit.spades, rank: Rank.king);
      final hand = Hand([card1, card2]);
      
      final newHand = hand.removeCard(card1);
      
      expect(newHand.size, 1);
      expect(newHand.cards.first, card2);
    });

    test('should replace card in hand', () {
      const oldCard = Card(suit: Suit.hearts, rank: Rank.ace);
      const keepCard = Card(suit: Suit.spades, rank: Rank.king);
      const newCard = Card(suit: Suit.diamonds, rank: Rank.queen);
      
      final hand = Hand([oldCard, keepCard]);
      final updatedHand = hand.replaceCard(oldCard, newCard);
      
      expect(updatedHand.size, 2);
      expect(updatedHand.cards.contains(newCard), true);
      expect(updatedHand.cards.contains(oldCard), false);
      expect(updatedHand.cards.contains(keepCard), true);
    });

    test('should check if hand is full', () {
      final emptyHand = Hand.empty();
      final partialHand = Hand([const Card(suit: Suit.hearts, rank: Rank.ace)]);
      final fullHand = Hand([
        const Card(suit: Suit.hearts, rank: Rank.ace),
        const Card(suit: Suit.spades, rank: Rank.king),
        const Card(suit: Suit.diamonds, rank: Rank.queen),
      ]);
      
      expect(emptyHand.isFull, false);
      expect(partialHand.isFull, false);
      expect(fullHand.isFull, true);
    });
  });
}

