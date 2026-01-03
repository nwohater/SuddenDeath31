import '../entities/card.dart';
import '../entities/hand.dart';
import '../entities/player.dart';
import '../entities/round_state.dart';

/// Use case for dealing initial hands to all players
class DealInitialHandsUseCase {
  /// Deal 3 cards to each player and set up the round
  RoundState execute({
    required List<Player> players,
    required int openerIndex,
    required int betAmount,
  }) {
    // Create and shuffle deck
    final deck = Card.shuffleDeck(Card.createDeck());
    
    // Deal 3 cards to each player
    final updatedPlayers = <Player>[];
    int cardIndex = 0;
    
    for (final player in players) {
      final cards = [
        deck[cardIndex++],
        deck[cardIndex++],
        deck[cardIndex++],
      ];
      updatedPlayers.add(player.updateHand(Hand(cards)));
    }
    
    // Place one card in discard pile
    final discardPile = [deck[cardIndex++]];
    
    // Remaining cards go to deck
    final remainingDeck = deck.sublist(cardIndex);
    
    // Calculate total turns based on bet amount (turns per player)
    final turnsPerPlayer = _getTurnsPerPlayer(betAmount);
    final totalActions = turnsPerPlayer * players.length;

    // Check if Sudden Death mode
    final isSuddenDeath = players.every((p) => p.chips <= 2);

    // Collect bets from all players
    final playersAfterBet = updatedPlayers.map((p) {
      return p.removeChips(betAmount);
    }).toList();

    final pot = betAmount * players.length;

    return RoundState(
      players: playersAfterBet,
      deck: remainingDeck,
      discardPile: discardPile,
      pot: pot,
      betAmount: betAmount,
      totalTurns: totalActions,
      turnsRemaining: totalActions,
      currentPlayerIndex: openerIndex,
      openerIndex: openerIndex,
      isComplete: false,
      isSuddenDeathMode: isSuddenDeath,
    );
  }

  int _getTurnsPerPlayer(int betAmount) {
    if (betAmount <= 0) return 0;
    if (betAmount == 1) return 5;
    if (betAmount == 2) return 4;
    if (betAmount == 3) return 3;
    if (betAmount == 4) return 2;
    return 1; // 5 or more
  }
}

