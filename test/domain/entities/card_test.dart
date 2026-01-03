import 'package:flutter_test/flutter_test.dart';
import 'package:suddendeath31/domain/entities/card.dart';

void main() {
  group('Card Tests', () {
    test('should create a card with correct properties', () {
      const card = Card(suit: Suit.hearts, rank: Rank.ace);
      
      expect(card.suit, Suit.hearts);
      expect(card.rank, Rank.ace);
      expect(card.value, 11); // Ace is worth 11
      expect(card.display, 'A♥');
    });

    test('should create a full 52-card deck', () {
      final deck = Card.createDeck();
      
      expect(deck.length, 52);
      
      // Check all suits are present
      expect(deck.where((c) => c.suit == Suit.hearts).length, 13);
      expect(deck.where((c) => c.suit == Suit.diamonds).length, 13);
      expect(deck.where((c) => c.suit == Suit.clubs).length, 13);
      expect(deck.where((c) => c.suit == Suit.spades).length, 13);
    });

    test('should shuffle deck', () {
      final deck = Card.createDeck();
      final shuffled = Card.shuffleDeck(deck);
      
      expect(shuffled.length, 52);
      // Shuffled deck should have same cards but likely different order
      expect(shuffled, isNot(equals(deck)));
    });

    test('face cards should have value 10', () {
      const jack = Card(suit: Suit.spades, rank: Rank.jack);
      const queen = Card(suit: Suit.spades, rank: Rank.queen);
      const king = Card(suit: Suit.spades, rank: Rank.king);
      
      expect(jack.value, 10);
      expect(queen.value, 10);
      expect(king.value, 10);
    });

    test('number cards should have correct values', () {
      const two = Card(suit: Suit.clubs, rank: Rank.two);
      const five = Card(suit: Suit.clubs, rank: Rank.five);
      const nine = Card(suit: Suit.clubs, rank: Rank.nine);
      
      expect(two.value, 2);
      expect(five.value, 5);
      expect(nine.value, 9);
    });
  });

  group('Suit Tests', () {
    test('should have correct symbols', () {
      expect(Suit.hearts.symbol, '♥');
      expect(Suit.diamonds.symbol, '♦');
      expect(Suit.clubs.symbol, '♣');
      expect(Suit.spades.symbol, '♠');
    });

    test('should identify red and black suits', () {
      expect(Suit.hearts.isRed, true);
      expect(Suit.diamonds.isRed, true);
      expect(Suit.clubs.isBlack, true);
      expect(Suit.spades.isBlack, true);
    });
  });

  group('Rank Tests', () {
    test('should have correct symbols', () {
      expect(Rank.ace.symbol, 'A');
      expect(Rank.two.symbol, '2');
      expect(Rank.jack.symbol, 'J');
      expect(Rank.queen.symbol, 'Q');
      expect(Rank.king.symbol, 'K');
    });

    test('should have correct order for comparison', () {
      expect(Rank.ace.order, 1);
      expect(Rank.two.order, 2);
      expect(Rank.jack.order, 11);
      expect(Rank.queen.order, 12);
      expect(Rank.king.order, 13);
    });
  });
}

