import 'package:equatable/equatable.dart';

/// Represents a venue in Career mode
class Venue extends Equatable {
  final String id;
  final String name;
  final int minBuyIn; // Minimum chips required to enter
  final int startingChips; // Chips given at start of venue
  final int handsToPlay; // Number of hands in this venue (5, 10, or 15)
  final int qualifyLine; // Minimum chips to advance
  final int targetLine; // Chips needed to "win" venue (extra rewards)
  final String difficulty; // 'easy', 'medium', 'hard'

  const Venue({
    required this.id,
    required this.name,
    required this.minBuyIn,
    required this.startingChips,
    required this.handsToPlay,
    required this.qualifyLine,
    required this.targetLine,
    required this.difficulty,
  });

  /// Check if player qualifies to advance
  bool qualifies(int chips) => chips >= qualifyLine;

  /// Check if player won the venue (hit target)
  bool isWon(int chips) => chips >= targetLine;

  @override
  List<Object?> get props => [
        id,
        name,
        minBuyIn,
        startingChips,
        handsToPlay,
        qualifyLine,
        targetLine,
        difficulty,
      ];

  @override
  String toString() => '$name ($handsToPlay hands)';
}

/// Predefined venues for Career mode
class Venues {
  static const venueA = Venue(
    id: 'venue_a',
    name: 'The Corner Pub',
    minBuyIn: 10,
    startingChips: 20,
    handsToPlay: 5,
    qualifyLine: 14,
    targetLine: 26,
    difficulty: 'easy',
  );

  static const venueB = Venue(
    id: 'venue_b',
    name: 'Downtown Casino',
    minBuyIn: 15,
    startingChips: 25,
    handsToPlay: 10,
    qualifyLine: 18,
    targetLine: 32,
    difficulty: 'medium',
  );

  static const venueC = Venue(
    id: 'venue_c',
    name: 'High Roller Suite',
    minBuyIn: 20,
    startingChips: 30,
    handsToPlay: 15,
    qualifyLine: 20,
    targetLine: 40,
    difficulty: 'hard',
  );

  static const all = [venueA, venueB, venueC];

  static Venue? getById(String id) {
    try {
      return all.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }
}

