import 'package:equatable/equatable.dart';
import 'card.dart';
import 'player.dart';

/// Represents the current state of a round
class RoundState extends Equatable {
  final List<Player> players;
  final List<Card> deck;
  final List<Card> discardPile;
  final int pot;
  final int betAmount;
  final int totalTurns; // Total turns allowed this round
  final int turnsRemaining;
  final int currentPlayerIndex;
  final int openerIndex; // Index of the player who opened betting
  final bool isComplete;
  final String? winnerId; // Player ID of winner (if round is complete)
  final bool isSuddenDeathMode; // True if all players have ≤2 chips

  const RoundState({
    required this.players,
    required this.deck,
    required this.discardPile,
    required this.pot,
    required this.betAmount,
    required this.totalTurns,
    required this.turnsRemaining,
    required this.currentPlayerIndex,
    required this.openerIndex,
    required this.isComplete,
    this.winnerId,
    required this.isSuddenDeathMode,
  });

  /// Create initial round state
  factory RoundState.initial({
    required List<Player> players,
    required int openerIndex,
  }) {
    return RoundState(
      players: players,
      deck: [],
      discardPile: [],
      pot: 0,
      betAmount: 0,
      totalTurns: 0,
      turnsRemaining: 0,
      currentPlayerIndex: 0,
      openerIndex: openerIndex,
      isComplete: false,
      winnerId: null,
      isSuddenDeathMode: false,
    );
  }

  /// Get current player
  Player get currentPlayer => players[currentPlayerIndex];

  /// Get opener
  Player get opener => players[openerIndex];

  /// Get top card of discard pile
  Card? get topDiscard => discardPile.isEmpty ? null : discardPile.last;

  /// Check if deck is empty
  bool get isDeckEmpty => deck.isEmpty;

  /// Update a specific player
  RoundState updatePlayer(String playerId, Player updatedPlayer) {
    final newPlayers = players.map((p) {
      return p.id == playerId ? updatedPlayer : p;
    }).toList();

    return copyWith(players: newPlayers);
  }

  /// Move to next player
  RoundState nextPlayer() {
    final nextIndex = (currentPlayerIndex + 1) % players.length;
    return copyWith(
      currentPlayerIndex: nextIndex,
      turnsRemaining: turnsRemaining - 1,
    );
  }

  /// Add to pot
  RoundState addToPot(int amount) {
    return copyWith(pot: pot + amount);
  }

  /// Draw card from deck
  RoundState drawCard() {
    if (deck.isEmpty) return this;
    
    final newDeck = List<Card>.from(deck);
    final drawnCard = newDeck.removeAt(0);
    
    return copyWith(deck: newDeck);
  }

  /// Add card to discard pile
  RoundState discard(Card card) {
    return copyWith(
      discardPile: [...discardPile, card],
    );
  }

  /// Complete the round
  RoundState complete(String winnerId) {
    return copyWith(
      isComplete: true,
      winnerId: winnerId,
    );
  }

  /// Copy with modifications
  RoundState copyWith({
    List<Player>? players,
    List<Card>? deck,
    List<Card>? discardPile,
    int? pot,
    int? betAmount,
    int? totalTurns,
    int? turnsRemaining,
    int? currentPlayerIndex,
    int? openerIndex,
    bool? isComplete,
    String? winnerId,
    bool? isSuddenDeathMode,
  }) {
    return RoundState(
      players: players ?? this.players,
      deck: deck ?? this.deck,
      discardPile: discardPile ?? this.discardPile,
      pot: pot ?? this.pot,
      betAmount: betAmount ?? this.betAmount,
      totalTurns: totalTurns ?? this.totalTurns,
      turnsRemaining: turnsRemaining ?? this.turnsRemaining,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      openerIndex: openerIndex ?? this.openerIndex,
      isComplete: isComplete ?? this.isComplete,
      winnerId: winnerId ?? this.winnerId,
      isSuddenDeathMode: isSuddenDeathMode ?? this.isSuddenDeathMode,
    );
  }

  @override
  List<Object?> get props => [
        players,
        deck,
        discardPile,
        pot,
        betAmount,
        totalTurns,
        turnsRemaining,
        currentPlayerIndex,
        openerIndex,
        isComplete,
        winnerId,
        isSuddenDeathMode,
      ];
}

