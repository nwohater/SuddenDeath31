import '../../domain/entities/game_state.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/round_state.dart';

/// Repository for managing in-memory game state
class GameRepository {
  GameState? _currentGame;
  
  /// Get the current game state
  GameState? get currentGame => _currentGame;
  
  /// Check if a game is in progress
  bool get hasActiveGame => _currentGame != null;
  
  /// Start a new game
  void startGame(GameState gameState) {
    _currentGame = gameState;
  }
  
  /// Update the current game state
  void updateGame(GameState gameState) {
    _currentGame = gameState;
  }
  
  /// Update the current round
  void updateRound(RoundState roundState) {
    if (_currentGame == null) {
      throw Exception('No active game');
    }
    _currentGame = _currentGame!.copyWith(currentRound: roundState);
  }
  
  /// Update players
  void updatePlayers(List<Player> players) {
    if (_currentGame == null) {
      throw Exception('No active game');
    }
    _currentGame = _currentGame!.copyWith(players: players);
  }
  
  /// Complete the current round
  void completeRound() {
    if (_currentGame == null) {
      throw Exception('No active game');
    }
    _currentGame = _currentGame!.copyWith(
      currentRound: null,
      roundNumber: _currentGame!.roundNumber + 1,
    );
  }
  
  /// End the current game
  void endGame() {
    _currentGame = null;
  }
  
  /// Clear all game data
  void clear() {
    _currentGame = null;
  }
}

