import 'package:equatable/equatable.dart';
import 'hand.dart';
import 'npc_profile.dart';

/// Represents a player in the game
class Player extends Equatable {
  final String id;
  final String name;
  final int chips;
  final Hand hand;
  final bool isNPC;
  final int position; // 0-3, clockwise from opener
  final NPCProfile? npcProfile; // Only for NPC players

  const Player({
    required this.id,
    required this.name,
    required this.chips,
    required this.hand,
    required this.isNPC,
    required this.position,
    this.npcProfile,
  });

  /// Create a human player
  factory Player.human({
    required String id,
    required String name,
    required int chips,
    required int position,
  }) {
    return Player(
      id: id,
      name: name,
      chips: chips,
      hand: Hand.empty(),
      isNPC: false,
      position: position,
      npcProfile: null,
    );
  }

  /// Create an NPC player
  factory Player.npc({
    required String id,
    required String name,
    required int chips,
    required int position,
    required NPCProfile profile,
  }) {
    return Player(
      id: id,
      name: name,
      chips: chips,
      hand: Hand.empty(),
      isNPC: true,
      position: position,
      npcProfile: profile,
    );
  }

  /// Check if player is broke
  bool get isBroke => chips <= 0;

  /// Check if player can afford a bet
  bool canAfford(int amount) => chips >= amount;

  /// Update chips
  Player updateChips(int newChips) {
    return Player(
      id: id,
      name: name,
      chips: newChips,
      hand: hand,
      isNPC: isNPC,
      position: position,
      npcProfile: npcProfile,
    );
  }

  /// Add chips
  Player addChips(int amount) {
    return updateChips(chips + amount);
  }

  /// Remove chips
  Player removeChips(int amount) {
    return updateChips(chips - amount);
  }

  /// Update hand
  Player updateHand(Hand newHand) {
    return Player(
      id: id,
      name: name,
      chips: chips,
      hand: newHand,
      isNPC: isNPC,
      position: position,
      npcProfile: npcProfile,
    );
  }

  /// Clear hand
  Player clearHand() {
    return updateHand(Hand.empty());
  }

  @override
  List<Object?> get props => [id, name, chips, hand, isNPC, position, npcProfile];

  @override
  String toString() => '$name (${chips}c) - ${hand.toString()}';
}

