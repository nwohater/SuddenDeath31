import 'dart:math';
import '../entities/card.dart';
import '../entities/hand.dart';
import '../entities/npc_profile.dart';
import '../entities/round_state.dart';
import '../usecases/play_turn_usecase.dart';

/// NPC decision result
class NPCDecision {
  final int betAmount;
  final TurnAction? turnAction;
  final Card? cardToDiscard;
  final Card? cardToSwap;

  const NPCDecision({
    required this.betAmount,
    this.turnAction,
    this.cardToDiscard,
    this.cardToSwap,
  });
}

/// AI engine for NPC decision-making
class NPCDecisionEngine {
  final Random _random = Random();

  /// Decide bet amount for opening a round
  int decideBetAmount({
    required NPCProfile profile,
    required Hand hand,
    required int maxBet,
    required int currentChips,
  }) {
    if (maxBet <= 0) return 0;

    // Evaluate hand strength (0.0 to 1.0)
    final handStrength = _evaluateHandStrength(hand);

    // Base bet on hand strength and aggression
    final aggressionFactor = profile.betAggression;
    final bluffFactor = profile.bluffTendency;

    // Calculate base bet
    double betFactor;
    if (handStrength > 0.7) {
      // Strong hand: bet based on aggression
      betFactor = 0.6 + (aggressionFactor * 0.4);
    } else if (handStrength > 0.4) {
      // Medium hand: bet conservatively
      betFactor = 0.3 + (aggressionFactor * 0.3);
    } else {
      // Weak hand: bluff or bet low
      if (_random.nextDouble() < bluffFactor) {
        betFactor = 0.4 + (bluffFactor * 0.3); // Bluff bet
      } else {
        betFactor = 0.2 + (aggressionFactor * 0.2); // Conservative bet
      }
    }

    // Add some randomness
    betFactor += (_random.nextDouble() - 0.5) * 0.2;
    betFactor = betFactor.clamp(0.0, 1.0);

    // Calculate actual bet
    int bet = (maxBet * betFactor).round();
    bet = bet.clamp(1, maxBet);

    return bet;
  }

  /// Decide turn action (draw or swap)
  NPCDecision decideTurnAction({
    required NPCProfile profile,
    required Hand hand,
    required Card topDiscard,
    required RoundState roundState,
  }) {
    // Evaluate current hand
    final currentStrength = _evaluateHandStrength(hand);
    
    // Check if top discard would improve hand
    final wouldImprove = _wouldDiscardImproveHand(hand, topDiscard, profile);

    // Decide: swap or draw?
    TurnAction action;
    Card? cardToSwap;
    Card? cardToDiscard;

    if (wouldImprove && _random.nextDouble() < profile.swapPreference) {
      // Swap with discard pile
      action = TurnAction.swapWithDiscard;
      cardToSwap = _chooseCardToSwap(hand, topDiscard, profile);
      cardToDiscard = topDiscard; // Not used in swap, but for consistency
    } else {
      // Draw from deck
      action = TurnAction.drawAndDiscard;
      // Simulate drawing a random card for decision
      cardToDiscard = _chooseCardToDiscard(hand, profile);
    }

    return NPCDecision(
      betAmount: 0, // Not used for turn actions
      turnAction: action,
      cardToDiscard: cardToDiscard,
      cardToSwap: cardToSwap,
    );
  }

  /// Evaluate hand strength (0.0 = worst, 1.0 = best)
  double _evaluateHandStrength(Hand hand) {
    final value = hand.value;
    
    // Check for instant wins
    if (hand.hasInstantWin) return 1.0;
    
    // Normalize value (0-31 range)
    // 31 = 1.0, 0 = 0.0
    return (value / 31.0).clamp(0.0, 1.0);
  }

  /// Check if discard card would improve hand
  bool _wouldDiscardImproveHand(Hand hand, Card discard, NPCProfile profile) {
    final currentValue = hand.value;
    
    // Try replacing each card with the discard
    for (final card in hand.cards) {
      final newHand = hand.replaceCard(card, discard);
      if (newHand.value > currentValue) {
        return true;
      }
      
      // Check for potential blitz (if NPC chases blitzes)
      if (profile.blitzChasing > 0.5 && _hasBlitzPotential(newHand)) {
        return true;
      }
    }
    
    return false;
  }

  /// Choose which card to swap out
  Card _chooseCardToSwap(Hand hand, Card incoming, NPCProfile profile) {
    Card? worstCard;
    int bestImprovement = 0;

    for (final card in hand.cards) {
      final newHand = hand.replaceCard(card, incoming);
      final improvement = newHand.value - hand.value;
      
      if (improvement > bestImprovement) {
        bestImprovement = improvement;
        worstCard = card;
      }
    }

    return worstCard ?? hand.cards.first;
  }

  /// Choose which card to discard after drawing
  Card _chooseCardToDiscard(Hand hand, NPCProfile profile) {
    // Find the card that contributes least to the best suit
    final cards = hand.cards;
    final suits = {Suit.hearts, Suit.diamonds, Suit.clubs, Suit.spades};
    
    int bestSuitValue = 0;
    Suit? bestSuit;
    
    for (final suit in suits) {
      final suitValue = cards
          .where((c) => c.suit == suit)
          .fold(0, (sum, c) => sum + c.value);
      if (suitValue > bestSuitValue) {
        bestSuitValue = suitValue;
        bestSuit = suit;
      }
    }

    // Discard card not in best suit, or lowest value in best suit
    final cardsNotInBestSuit = cards.where((c) => c.suit != bestSuit).toList();
    if (cardsNotInBestSuit.isNotEmpty) {
      return cardsNotInBestSuit.reduce((a, b) => a.value < b.value ? a : b);
    }

    // All cards same suit, discard lowest
    return cards.reduce((a, b) => a.value < b.value ? a : b);
  }

  /// Check if hand has potential for blitz (three of a kind)
  bool _hasBlitzPotential(Hand hand) {
    final ranks = hand.cards.map((c) => c.rank).toList();
    final rankCounts = <Rank, int>{};
    
    for (final rank in ranks) {
      rankCounts[rank] = (rankCounts[rank] ?? 0) + 1;
    }
    
    return rankCounts.values.any((count) => count >= 2);
  }
}

