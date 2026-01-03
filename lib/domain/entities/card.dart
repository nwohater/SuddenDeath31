import 'package:equatable/equatable.dart';

/// Represents a playing card suit
enum Suit {
  hearts,
  diamonds,
  clubs,
  spades;

  String get symbol {
    switch (this) {
      case Suit.hearts:
        return '♥';
      case Suit.diamonds:
        return '♦';
      case Suit.clubs:
        return '♣';
      case Suit.spades:
        return '♠';
    }
  }

  bool get isRed => this == Suit.hearts || this == Suit.diamonds;
  bool get isBlack => this == Suit.clubs || this == Suit.spades;
}

/// Represents a playing card rank
enum Rank {
  ace(1, 11), // Ace is worth 11 in this game
  two(2, 2),
  three(3, 3),
  four(4, 4),
  five(5, 5),
  six(6, 6),
  seven(7, 7),
  eight(8, 8),
  nine(9, 9),
  ten(10, 10),
  jack(11, 10),
  queen(12, 10),
  king(13, 10);

  final int order; // For comparison
  final int value; // For scoring

  const Rank(this.order, this.value);

  String get symbol {
    switch (this) {
      case Rank.ace:
        return 'A';
      case Rank.two:
        return '2';
      case Rank.three:
        return '3';
      case Rank.four:
        return '4';
      case Rank.five:
        return '5';
      case Rank.six:
        return '6';
      case Rank.seven:
        return '7';
      case Rank.eight:
        return '8';
      case Rank.nine:
        return '9';
      case Rank.ten:
        return '10';
      case Rank.jack:
        return 'J';
      case Rank.queen:
        return 'Q';
      case Rank.king:
        return 'K';
    }
  }
}

/// Represents a single playing card
class Card extends Equatable {
  final Suit suit;
  final Rank rank;

  const Card({
    required this.suit,
    required this.rank,
  });

  /// The value of this card for scoring purposes
  int get value => rank.value;

  /// String representation for display
  String get display => '${rank.symbol}${suit.symbol}';

  /// Create a standard 52-card deck
  static List<Card> createDeck() {
    final deck = <Card>[];
    for (final suit in Suit.values) {
      for (final rank in Rank.values) {
        deck.add(Card(suit: suit, rank: rank));
      }
    }
    return deck;
  }

  /// Shuffle a deck of cards
  static List<Card> shuffleDeck(List<Card> deck) {
    final shuffled = List<Card>.from(deck);
    shuffled.shuffle();
    return shuffled;
  }

  @override
  List<Object?> get props => [suit, rank];

  @override
  String toString() => display;
}

