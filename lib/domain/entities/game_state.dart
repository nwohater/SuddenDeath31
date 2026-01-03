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
  final RoundState? currentRound;
  final bool isComplete;
  final String? winnerId;

  const GameState({
    required this.players,
    required this.mode,
    required this.roundNumber,
    required this.totalRounds,
    this.currentRound,
    this.isComplete = false,
    this.winnerId,
  });

  GameState copyWith({
    List<Player>? players,
    GameMode? mode,
    int? roundNumber,
    int? totalRounds,
    RoundState? currentRound,
    bool? isComplete,
    String? winnerId,
  }) {
    return GameState(
      players: players ?? this.players,
      mode: mode ?? this.mode,
      roundNumber: roundNumber ?? this.roundNumber,
      totalRounds: totalRounds ?? this.totalRounds,
      currentRound: currentRound ?? this.currentRound,
      isComplete: isComplete ?? this.isComplete,
      winnerId: winnerId ?? this.winnerId,
    );
  }
}

