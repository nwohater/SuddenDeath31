import '../entities/card.dart';
import '../entities/hand.dart';
import '../entities/player.dart';
import '../entities/round_state.dart';

/// Represents a player's turn action
enum TurnAction {
  drawAndDiscard, // Draw from deck, discard one card
  swapWithDiscard, // Swap one card with top of discard pile
}

/// Result of playing a turn
class PlayTurnResult {
  final RoundState newState;
  final bool isInstantWin;
  final String? winnerId;

  const PlayTurnResult({
    required this.newState,
    required this.isInstantWin,
    this.winnerId,
  });
}

/// Use case for playing a turn (draw+discard or swap)
class PlayTurnUseCase {
  /// Execute a turn action
  PlayTurnResult execute({
    required RoundState state,
    required String playerId,
    required TurnAction action,
    required Card cardToDiscard, // Card player wants to discard
    Card? cardToSwap, // Card from hand to swap (for swap action)
  }) {
    final player = state.players.firstWhere((p) => p.id == playerId);
    
    RoundState newState;
    
    if (action == TurnAction.drawAndDiscard) {
      newState = _executeDrawAndDiscard(
        state: state,
        player: player,
        cardToDiscard: cardToDiscard,
      );
    } else {
      newState = _executeSwap(
        state: state,
        player: player,
        cardToSwap: cardToSwap!,
      );
    }
    
    // Check for instant win
    final updatedPlayer = newState.players.firstWhere((p) => p.id == playerId);
    final hasInstantWin = updatedPlayer.hand.hasInstantWin;
    
    // Move to next player if no instant win
    if (!hasInstantWin) {
      newState = newState.nextPlayer();
    }
    
    return PlayTurnResult(
      newState: newState,
      isInstantWin: hasInstantWin,
      winnerId: hasInstantWin ? playerId : null,
    );
  }
  
  RoundState _executeDrawAndDiscard({
    required RoundState state,
    required Player player,
    required Card cardToDiscard,
  }) {
    // Draw card from deck
    if (state.deck.isEmpty) {
      throw Exception('Deck is empty, cannot draw');
    }
    
    final drawnCard = state.deck.first;
    final newDeck = state.deck.sublist(1);
    
    // Add drawn card to hand, remove discarded card
    final newHand = player.hand.removeCard(cardToDiscard).addCard(drawnCard);
    final updatedPlayer = player.updateHand(newHand);
    
    // Add discarded card to discard pile
    final newDiscardPile = [...state.discardPile, cardToDiscard];
    
    // Update state
    return state.copyWith(
      players: state.players.map((p) => p.id == player.id ? updatedPlayer : p).toList(),
      deck: newDeck,
      discardPile: newDiscardPile,
    );
  }
  
  RoundState _executeSwap({
    required RoundState state,
    required Player player,
    required Card cardToSwap,
  }) {
    if (state.discardPile.isEmpty) {
      throw Exception('Discard pile is empty, cannot swap');
    }
    
    final topDiscard = state.discardPile.last;
    
    // Swap card in hand with top of discard
    final newHand = player.hand.replaceCard(cardToSwap, topDiscard);
    final updatedPlayer = player.updateHand(newHand);
    
    // Update discard pile (remove top, add swapped card)
    final newDiscardPile = [...state.discardPile.sublist(0, state.discardPile.length - 1), cardToSwap];
    
    // Update state
    return state.copyWith(
      players: state.players.map((p) => p.id == player.id ? updatedPlayer : p).toList(),
      discardPile: newDiscardPile,
    );
  }
}

