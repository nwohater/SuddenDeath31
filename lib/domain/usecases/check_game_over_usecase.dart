import '../entities/player.dart';

/// Result of checking if game is over
class GameOverResult {
  final bool isGameOver;
  final String? winnerId;
  final List<String> eliminatedPlayerIds;

  const GameOverResult({
    required this.isGameOver,
    this.winnerId,
    this.eliminatedPlayerIds = const [],
  });
}

/// Use case for checking if the game is over
class CheckGameOverUseCase {
  /// Check if game is over (only one player has chips remaining)
  GameOverResult execute(List<Player> players) {
    final playersWithChips = players.where((p) => p.chips > 0).toList();
    final eliminatedPlayers = players.where((p) => p.chips <= 0).map((p) => p.id).toList();
    
    if (playersWithChips.length == 1) {
      return GameOverResult(
        isGameOver: true,
        winnerId: playersWithChips.first.id,
        eliminatedPlayerIds: eliminatedPlayers,
      );
    }
    
    return GameOverResult(
      isGameOver: false,
      eliminatedPlayerIds: eliminatedPlayers,
    );
  }
}

