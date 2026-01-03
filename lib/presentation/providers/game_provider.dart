import 'package:flutter/foundation.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/round_state.dart';
import '../../domain/usecases/deal_initial_hands_usecase.dart';
import '../../domain/usecases/play_turn_usecase.dart';
import '../../domain/usecases/resolve_round_usecase.dart';
import '../../domain/usecases/check_game_over_usecase.dart';
import '../../domain/usecases/validate_bet_usecase.dart';
import '../../data/repositories/game_repository.dart';

/// Provider for managing game state
class GameProvider extends ChangeNotifier {
  final GameRepository _gameRepository;
  final DealInitialHandsUseCase _dealInitialHandsUseCase;
  final PlayTurnUseCase _playTurnUseCase;
  final ResolveRoundUseCase _resolveRoundUseCase;
  final CheckGameOverUseCase _checkGameOverUseCase;
  final ValidateBetUseCase _validateBetUseCase;

  GameProvider({
    required GameRepository gameRepository,
    required DealInitialHandsUseCase dealInitialHandsUseCase,
    required PlayTurnUseCase playTurnUseCase,
    required ResolveRoundUseCase resolveRoundUseCase,
    required CheckGameOverUseCase checkGameOverUseCase,
    required ValidateBetUseCase validateBetUseCase,
  })  : _gameRepository = gameRepository,
        _dealInitialHandsUseCase = dealInitialHandsUseCase,
        _playTurnUseCase = playTurnUseCase,
        _resolveRoundUseCase = resolveRoundUseCase,
        _checkGameOverUseCase = checkGameOverUseCase,
        _validateBetUseCase = validateBetUseCase;

  GameState? get currentGame => _gameRepository.currentGame;
  RoundState? get currentRound => currentGame?.currentRound;
  List<Player> get players => currentGame?.players ?? [];
  bool get hasActiveGame => _gameRepository.hasActiveGame;
  bool get isGameOver => currentGame?.isComplete ?? false;

  /// Start a new game
  void startGame({
    required List<Player> players,
    required GameMode mode,
  }) {
    final gameState = GameState(
      players: players,
      mode: mode,
      roundNumber: 0,
      isComplete: false,
    );
    _gameRepository.startGame(gameState);
    notifyListeners();
  }

  /// Deal cards (before betting)
  void dealCards() {
    if (currentGame == null) return;

    // Deal cards with a temporary bet of 1 (will be updated after betting)
    final roundState = _dealInitialHandsUseCase.execute(
      players: players,
      openerIndex: 0, // TODO: Rotate opener
      betAmount: 1, // Temporary, will be updated
    );

    _gameRepository.updateGame(
      currentGame!.copyWith(
        currentRound: roundState,
        players: roundState.players,
      ),
    );
    notifyListeners();
  }

  /// Start a new round with betting
  void startRound({required int betAmount}) {
    if (currentGame == null || currentRound == null) return;

    // Validate bet
    final validation = _validateBetUseCase.execute(
      players: players,
      betAmount: betAmount,
    );

    if (!validation.isValid) {
      throw Exception(validation.errorMessage);
    }

    // Update the round with the actual bet amount and recalculate turns
    final turnsPerPlayer = _getTurnsPerPlayer(betAmount);
    final totalActions = turnsPerPlayer * players.length;
    final updatedRound = currentRound!.copyWith(
      betAmount: betAmount,
      totalTurns: totalActions,
      turnsRemaining: totalActions,
      pot: betAmount * players.length,
    );

    _gameRepository.updateRound(updatedRound);
    notifyListeners();
  }

  int _getTurnsPerPlayer(int betAmount) {
    if (betAmount <= 0) return 0;
    if (betAmount == 1) return 5;
    if (betAmount == 2) return 4;
    if (betAmount == 3) return 3;
    if (betAmount == 4) return 2;
    return 1; // 5 or more
  }

  /// Play a turn
  void playTurn({
    required String playerId,
    required TurnAction action,
    required Card cardToDiscard,
    Card? cardToSwap,
  }) {
    if (currentRound == null) return;

    final result = _playTurnUseCase.execute(
      state: currentRound!,
      playerId: playerId,
      action: action,
      cardToDiscard: cardToDiscard,
      cardToSwap: cardToSwap,
    );

    if (result.isInstantWin) {
      // Handle instant win
      _resolveRound(instantWinnerId: result.winnerId);
    } else {
      // Update round state
      _gameRepository.updateRound(result.newState);
      notifyListeners();

      // Check if round is over (no turns remaining)
      if (result.newState.turnsRemaining <= 0) {
        _resolveRound();
      }
    }
  }

  /// Resolve the current round
  void _resolveRound({String? instantWinnerId}) {
    if (currentRound == null) return;

    final resolution = _resolveRoundUseCase.execute(
      state: currentRound!,
      instantWinnerId: instantWinnerId,
    );

    // Update players with new chip counts
    _gameRepository.updatePlayers(resolution.updatedPlayers);

    // Check if game is over
    final gameOverResult = _checkGameOverUseCase.execute(resolution.updatedPlayers);

    if (gameOverResult.isGameOver) {
      _gameRepository.updateGame(
        currentGame!.copyWith(
          isComplete: true,
          winnerId: gameOverResult.winnerId,
        ),
      );
    } else {
      // Complete the round
      _gameRepository.completeRound();
    }

    notifyListeners();
  }

  /// End the current game
  void endGame() {
    _gameRepository.endGame();
    notifyListeners();
  }

  /// Clear all game data
  void clearGame() {
    _gameRepository.clear();
    notifyListeners();
  }
}

