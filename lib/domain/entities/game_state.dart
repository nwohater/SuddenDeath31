import 'player.dart';
import 'round_state.dart';

/// Game mode enum
enum GameMode {
  practice,
  career,
  highStakes,
}

/// Overall game state
class GameState {
  final List<Player> players;
  final GameMode mode;
  final int roundNumber;
  final int totalRounds; // Total rounds in this game (5, 10, or 15)
  final int openerIndex; // Index of player who will open betting next round
  final RoundState? currentRound;
  final bool isComplete;
  final String? winnerId;

  const GameState({
    required this.players,
    required this.mode,
    required this.roundNumber,
    required this.totalRounds,
    this.openerIndex = 0,
    this.currentRound,
    this.isComplete = false,
    this.winnerId,
  });

  GameState copyWith({
    List<Player>? players,
    GameMode? mode,
    int? roundNumber,
    int? totalRounds,
    int? openerIndex,
    RoundState? currentRound,
    bool? isComplete,
    String? winnerId,
    bool clearCurrentRound = false,
    bool clearWinnerId = false,
  }) {
    return GameState(
      players: players ?? this.players,
      mode: mode ?? this.mode,
      roundNumber: roundNumber ?? this.roundNumber,
      totalRounds: totalRounds ?? this.totalRounds,
      openerIndex: openerIndex ?? this.openerIndex,
      currentRound: clearCurrentRound ? null : (currentRound ?? this.currentRound),
      isComplete: isComplete ?? this.isComplete,
      winnerId: clearWinnerId ? null : (winnerId ?? this.winnerId),
    );
  }
}

