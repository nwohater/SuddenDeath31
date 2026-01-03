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

  /// Start a new round
  void startRound({required int betAmount}) {
    if (currentGame == null) return;

    // Validate bet
    final validation = _validateBetUseCase.execute(
      players: players,
      betAmount: betAmount,
    );

    if (!validation.isValid) {
      throw Exception(validation.errorMessage);
    }

    // Deal initial hands
    final roundState = _dealInitialHandsUseCase.execute(
      players: players,
      openerIndex: 0, // TODO: Rotate opener
      betAmount: betAmount,
    );

    _gameRepository.updateGame(
      currentGame!.copyWith(
        currentRound: roundState,
        players: roundState.players,
      ),
    );
    notifyListeners();
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

