import '../entities/player.dart';
import '../entities/round_state.dart';

/// Result of resolving a round
class RoundResolution {
  final String winnerId;
  final int winAmount;
  final List<Player> updatedPlayers;
  final bool wasInstantWin;
  final bool wasSuddenDeath;

  const RoundResolution({
    required this.winnerId,
    required this.winAmount,
    required this.updatedPlayers,
    required this.wasInstantWin,
    required this.wasSuddenDeath,
  });
}

/// Use case for resolving a round and determining the winner
class ResolveRoundUseCase {
  /// Resolve the round and award chips to winner
  RoundResolution execute({
    required RoundState state,
    String? instantWinnerId,
  }) {
    final wasInstantWin = instantWinnerId != null;
    
    String winnerId;
    if (wasInstantWin) {
      winnerId = instantWinnerId;
    } else {
      // Find player with highest hand value (closest to 31)
      winnerId = _findHighestHandWinner(state.players);
    }

    // Award pot to winner
    final updatedPlayers = state.players.map((player) {
      if (player.id == winnerId) {
        return player.addChips(state.pot);
      }
      return player;
    }).toList();

    return RoundResolution(
      winnerId: winnerId,
      winAmount: state.pot,
      updatedPlayers: updatedPlayers,
      wasInstantWin: wasInstantWin,
      wasSuddenDeath: state.isSuddenDeathMode,
    );
  }

  String _findHighestHandWinner(List<Player> players) {
    Player? highestPlayer;
    int highestValue = -1;

    for (final player in players) {
      final handValue = player.hand.value;
      if (handValue > highestValue) {
        highestValue = handValue;
        highestPlayer = player;
      }
    }

    if (highestPlayer == null) {
      throw Exception('No winner found');
    }

    return highestPlayer.id;
  }
}

