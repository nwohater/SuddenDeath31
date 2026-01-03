import 'player.dart';
import 'hand.dart';

/// Core game rules and logic for Sudden Death 31
class GameRules {
  /// Map bet amount to total turns allowed
  /// Bet 1 → 5 turns, Bet 2 → 4 turns, Bet 3 → 3 turns, Bet 4 → 2 turns, Bet 5+ → 1 turn
  static int getTotalTurns(int betAmount) {
    if (betAmount <= 0) return 0;
    if (betAmount == 1) return 5;
    if (betAmount == 2) return 4;
    if (betAmount == 3) return 3;
    if (betAmount == 4) return 2;
    return 1; // 5 or more
  }

  /// Calculate maximum bet allowed (smallest chip stack at table)
  static int getMaxBet(List<Player> players) {
    if (players.isEmpty) return 0;
    return players.map((p) => p.chips).reduce((a, b) => a < b ? a : b);
  }

  /// Check if Sudden Death mode should be triggered
  /// All players must have ≤ 2 chips
  static bool isSuddenDeathMode(List<Player> players) {
    if (players.isEmpty) return false;
    return players.every((p) => p.chips <= 2);
  }

  /// Get forced bet amount in Sudden Death mode
  static int getSuddenDeathBet() => 1;

  /// Determine winner(s) of a round based on hand scores
  /// Returns list of player IDs (can be multiple in case of tie)
  static List<String> determineWinners(List<Player> players) {
    if (players.isEmpty) return [];

    // Find highest score
    int highestScore = 0;
    for (final player in players) {
      if (player.hand.score > highestScore) {
        highestScore = player.hand.score;
      }
    }

    // Get all players with highest score
    final topPlayers = players
        .where((p) => p.hand.score == highestScore)
        .toList();

    if (topPlayers.length == 1) {
      return [topPlayers.first.id];
    }

    // Multiple players tied - apply tie-breaker
    return applyTieBreaker(topPlayers);
  }

  /// Apply tie-breaker rules
  /// 1. Highest card in scoring suit
  /// 2. Second highest card
  /// 3. Third highest card
  /// 4. Still tied → split pot
  static List<String> applyTieBreaker(List<Player> tiedPlayers) {
    if (tiedPlayers.isEmpty) return [];
    if (tiedPlayers.length == 1) return [tiedPlayers.first.id];

    // Get scoring cards for each player (already sorted descending)
    final playerCards = <String, List<int>>{};
    for (final player in tiedPlayers) {
      final scoringCards = player.hand.scoringCards;
      playerCards[player.id] = scoringCards.map((c) => c.rank.order).toList();
    }

    // Compare cards position by position (0 = highest, 1 = second, 2 = third)
    for (int position = 0; position < 3; position++) {
      int highestRank = 0;
      
      // Find highest rank at this position
      for (final ranks in playerCards.values) {
        if (position < ranks.length && ranks[position] > highestRank) {
          highestRank = ranks[position];
        }
      }

      // Filter to players with highest rank at this position
      final remainingPlayers = <String>[];
      playerCards.forEach((playerId, ranks) {
        if (position < ranks.length && ranks[position] == highestRank) {
          remainingPlayers.add(playerId);
        }
      });

      if (remainingPlayers.length == 1) {
        return remainingPlayers;
      }

      // If still tied, continue to next position
      if (remainingPlayers.isNotEmpty) {
        // Filter playerCards to only remaining players
        playerCards.removeWhere((id, _) => !remainingPlayers.contains(id));
      }
    }

    // Still tied after all comparisons - split pot
    return playerCards.keys.toList();
  }

  /// Distribute pot among winners
  /// Returns map of player ID to chips won
  /// Handles odd chip rule: extra chip goes to player closest clockwise to opener
  static Map<String, int> distributePot({
    required int pot,
    required List<String> winnerIds,
    required List<Player> allPlayers,
    required int openerIndex,
  }) {
    if (winnerIds.isEmpty || pot <= 0) return {};

    final distribution = <String, int>{};
    final baseAmount = pot ~/ winnerIds.length;
    final remainder = pot % winnerIds.length;

    // Give base amount to all winners
    for (final winnerId in winnerIds) {
      distribution[winnerId] = baseAmount;
    }

    // Distribute remainder (odd chips)
    if (remainder > 0 && winnerIds.length > 1) {
      // Find winner closest clockwise to opener
      final winnerPositions = <int, String>{};
      for (final player in allPlayers) {
        if (winnerIds.contains(player.id)) {
          winnerPositions[player.position] = player.id;
        }
      }

      // Find closest clockwise position
      int closestPosition = -1;
      int minDistance = allPlayers.length + 1;

      winnerPositions.forEach((position, playerId) {
        int distance = (position - openerIndex) % allPlayers.length;
        if (distance < 0) distance += allPlayers.length;
        
        if (distance < minDistance) {
          minDistance = distance;
          closestPosition = position;
        }
      });

      if (closestPosition >= 0) {
        final luckyWinnerId = winnerPositions[closestPosition]!;
        distribution[luckyWinnerId] = distribution[luckyWinnerId]! + remainder;
      }
    }

    return distribution;
  }
}

