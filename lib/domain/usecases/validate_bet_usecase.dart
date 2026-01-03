import '../entities/player.dart';

/// Result of validating a bet
class BetValidationResult {
  final bool isValid;
  final String? errorMessage;
  final int maxAllowedBet;

  const BetValidationResult({
    required this.isValid,
    this.errorMessage,
    required this.maxAllowedBet,
  });
}

/// Use case for validating if a bet amount is valid
class ValidateBetUseCase {
  /// Validate if all players can afford the bet
  BetValidationResult execute({
    required List<Player> players,
    required int betAmount,
  }) {
    if (betAmount < 1) {
      return BetValidationResult(
        isValid: false,
        errorMessage: 'Bet must be at least 1 chip',
        maxAllowedBet: _getMaxBet(players),
      );
    }
    
    if (betAmount > 5) {
      return BetValidationResult(
        isValid: false,
        errorMessage: 'Maximum bet is 5 chips',
        maxAllowedBet: 5,
      );
    }
    
    // Check if all players can afford the bet
    final canAllAfford = players.every((p) => p.chips >= betAmount);
    
    if (!canAllAfford) {
      final maxBet = _getMaxBet(players);
      return BetValidationResult(
        isValid: false,
        errorMessage: 'Not all players can afford $betAmount chips. Maximum bet: $maxBet',
        maxAllowedBet: maxBet,
      );
    }
    
    return BetValidationResult(
      isValid: true,
      maxAllowedBet: _getMaxBet(players),
    );
  }
  
  int _getMaxBet(List<Player> players) {
    if (players.isEmpty) return 0;
    
    // Find minimum chips among all players
    int minChips = players.map((p) => p.chips).reduce((a, b) => a < b ? a : b);
    
    // Cap at 5 (max bet)
    return minChips > 5 ? 5 : minChips;
  }
}

