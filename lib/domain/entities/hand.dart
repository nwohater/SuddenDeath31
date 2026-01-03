import 'package:equatable/equatable.dart';
import 'card.dart';

/// Represents a player's hand of 3 cards
class Hand extends Equatable {
  final List<Card> cards;

  const Hand(this.cards);

  /// Create an empty hand
  factory Hand.empty() => const Hand([]);

  /// Number of cards in hand
  int get size => cards.length;

  /// Check if hand is full (3 cards)
  bool get isFull => cards.length == 3;

  /// Check if hand is empty
  bool get isEmpty => cards.isEmpty;

  /// Calculate the best single-suit total in this hand
  /// Returns the highest sum of cards in the same suit
  int get score {
    if (cards.isEmpty) return 0;

    final suitTotals = <Suit, int>{};
    for (final card in cards) {
      suitTotals[card.suit] = (suitTotals[card.suit] ?? 0) + card.value;
    }

    return suitTotals.values.reduce((a, b) => a > b ? a : b);
  }

  /// Get the suit that produces the best score
  Suit? get scoringSuit {
    if (cards.isEmpty) return null;

    final suitTotals = <Suit, int>{};
    for (final card in cards) {
      suitTotals[card.suit] = (suitTotals[card.suit] ?? 0) + card.value;
    }

    Suit? bestSuit;
    int bestTotal = 0;
    suitTotals.forEach((suit, total) {
      if (total > bestTotal) {
        bestTotal = total;
        bestSuit = suit;
      }
    });

    return bestSuit;
  }

  /// Get cards in the scoring suit, sorted by value (descending)
  List<Card> get scoringCards {
    final suit = scoringSuit;
    if (suit == null) return [];

    final cardsInSuit = cards.where((c) => c.suit == suit).toList();
    cardsInSuit.sort((a, b) => b.rank.order.compareTo(a.rank.order));
    return cardsInSuit;
  }

  /// Check if this hand is a "31" (three cards of same suit totaling 31)
  bool get is31 {
    if (cards.length != 3) return false;
    
    // All cards must be same suit
    final firstSuit = cards.first.suit;
    if (!cards.every((c) => c.suit == firstSuit)) return false;
    
    // Total must be 31
    final total = cards.fold<int>(0, (sum, card) => sum + card.value);
    return total == 31;
  }

  /// Check if this hand is a "Blitz" (three of a kind)
  bool get isBlitz {
    if (cards.length != 3) return false;
    
    final firstRank = cards.first.rank;
    return cards.every((c) => c.rank == firstRank);
  }

  /// Check if this hand has an instant win (31 or Blitz)
  bool get hasInstantWin => is31 || isBlitz;

  /// Add a card to the hand
  Hand addCard(Card card) {
    return Hand([...cards, card]);
  }

  /// Remove a card from the hand
  Hand removeCard(Card card) {
    final newCards = List<Card>.from(cards);
    newCards.remove(card);
    return Hand(newCards);
  }

  /// Replace a card in the hand
  Hand replaceCard(Card oldCard, Card newCard) {
    final newCards = List<Card>.from(cards);
    final index = newCards.indexOf(oldCard);
    if (index != -1) {
      newCards[index] = newCard;
    }
    return Hand(newCards);
  }

  @override
  List<Object?> get props => [cards];

  @override
  String toString() => cards.map((c) => c.display).join(', ');
}

