import 'package:flutter_test/flutter_test.dart';
import 'package:suddendeath31/domain/entities/card.dart';
import 'package:suddendeath31/domain/entities/hand.dart';
import 'package:suddendeath31/domain/entities/player.dart';
import 'package:suddendeath31/domain/entities/game_rules.dart';

void main() {
  group('Turn Limit Tests', () {
    test('should map bet to correct turn count', () {
      expect(GameRules.getTotalTurns(1), 5);
      expect(GameRules.getTotalTurns(2), 4);
      expect(GameRules.getTotalTurns(3), 3);
      expect(GameRules.getTotalTurns(4), 2);
      expect(GameRules.getTotalTurns(5), 1);
      expect(GameRules.getTotalTurns(10), 1);
    });

    test('should return 0 for invalid bet', () {
      expect(GameRules.getTotalTurns(0), 0);
      expect(GameRules.getTotalTurns(-1), 0);
    });
  });

  group('Max Bet Tests', () {
    test('should return smallest chip stack', () {
      final players = [
        Player.human(id: '1', name: 'P1', chips: 20, position: 0),
        Player.npc(id: '2', name: 'P2', chips: 15, position: 1),
        Player.npc(id: '3', name: 'P3', chips: 25, position: 2),
      ];

      expect(GameRules.getMaxBet(players), 15);
    });

    test('should return 0 for empty player list', () {
      expect(GameRules.getMaxBet([]), 0);
    });
  });

  group('Sudden Death Mode Tests', () {
    test('should trigger when all players have ≤2 chips', () {
      final players = [
        Player.human(id: '1', name: 'P1', chips: 2, position: 0),
        Player.npc(id: '2', name: 'P2', chips: 1, position: 1),
        Player.npc(id: '3', name: 'P3', chips: 2, position: 2),
      ];

      expect(GameRules.isSuddenDeathMode(players), true);
    });

    test('should not trigger if any player has >2 chips', () {
      final players = [
        Player.human(id: '1', name: 'P1', chips: 2, position: 0),
        Player.npc(id: '2', name: 'P2', chips: 3, position: 1),
        Player.npc(id: '3', name: 'P3', chips: 1, position: 2),
      ];

      expect(GameRules.isSuddenDeathMode(players), false);
    });

    test('should return forced bet of 1 in Sudden Death', () {
      expect(GameRules.getSuddenDeathBet(), 1);
    });
  });

  group('Winner Determination Tests', () {
    test('should determine single winner by highest score', () {
      final players = [
        Player.human(id: '1', name: 'P1', chips: 20, position: 0).updateHand(
          Hand([
            const Card(suit: Suit.hearts, rank: Rank.ten),
            const Card(suit: Suit.hearts, rank: Rank.five),
            const Card(suit: Suit.clubs, rank: Rank.two),
          ]),
        ), // Score: 15
        Player.npc(id: '2', name: 'P2', chips: 20, position: 1).updateHand(
          Hand([
            const Card(suit: Suit.spades, rank: Rank.king),
            const Card(suit: Suit.spades, rank: Rank.queen),
            const Card(suit: Suit.diamonds, rank: Rank.ace),
          ]),
        ), // Score: 20
      ];

      final winners = GameRules.determineWinners(players);
      expect(winners, ['2']);
    });

    test('should handle tie with multiple winners', () {
      final players = [
        Player.human(id: '1', name: 'P1', chips: 20, position: 0).updateHand(
          Hand([
            const Card(suit: Suit.hearts, rank: Rank.ten),
            const Card(suit: Suit.hearts, rank: Rank.five),
            const Card(suit: Suit.clubs, rank: Rank.two),
          ]),
        ), // Score: 15
        Player.npc(id: '2', name: 'P2', chips: 20, position: 1).updateHand(
          Hand([
            const Card(suit: Suit.spades, rank: Rank.ten),
            const Card(suit: Suit.spades, rank: Rank.five),
            const Card(suit: Suit.diamonds, rank: Rank.ace),
          ]),
        ), // Score: 15
      ];

      final winners = GameRules.determineWinners(players);
      expect(winners.length, 2);
      expect(winners.contains('1'), true);
      expect(winners.contains('2'), true);
    });
  });

  group('Tie-Breaker Tests', () {
    test('should break tie by highest card', () {
      final players = [
        Player.human(id: '1', name: 'P1', chips: 20, position: 0).updateHand(
          Hand([
            const Card(suit: Suit.hearts, rank: Rank.king), // 10
            const Card(suit: Suit.hearts, rank: Rank.five), // 5
            const Card(suit: Suit.clubs, rank: Rank.two),
          ]),
        ), // Score: 15, highest card: King
        Player.npc(id: '2', name: 'P2', chips: 20, position: 1).updateHand(
          Hand([
            const Card(suit: Suit.spades, rank: Rank.queen), // 10
            const Card(suit: Suit.spades, rank: Rank.five), // 5
            const Card(suit: Suit.diamonds, rank: Rank.ace),
          ]),
        ), // Score: 15, highest card: Queen
      ];

      final winners = GameRules.applyTieBreaker(players);
      expect(winners, ['1']); // King > Queen
    });

    test('should break tie by second highest card', () {
      final players = [
        Player.human(id: '1', name: 'P1', chips: 20, position: 0).updateHand(
          Hand([
            const Card(suit: Suit.hearts, rank: Rank.king),
            const Card(suit: Suit.hearts, rank: Rank.six),
            const Card(suit: Suit.clubs, rank: Rank.two),
          ]),
        ), // King, 6
        Player.npc(id: '2', name: 'P2', chips: 20, position: 1).updateHand(
          Hand([
            const Card(suit: Suit.spades, rank: Rank.king),
            const Card(suit: Suit.spades, rank: Rank.five),
            const Card(suit: Suit.diamonds, rank: Rank.ace),
          ]),
        ), // King, 5
      ];

      final winners = GameRules.applyTieBreaker(players);
      expect(winners, ['1']); // 6 > 5
    });
  });

  group('Pot Distribution Tests', () {
    test('should distribute pot evenly to single winner', () {
      final players = [
        Player.human(id: '1', name: 'P1', chips: 20, position: 0),
        Player.npc(id: '2', name: 'P2', chips: 20, position: 1),
      ];

      final distribution = GameRules.distributePot(
        pot: 10,
        winnerIds: ['1'],
        allPlayers: players,
        openerIndex: 0,
      );

      expect(distribution['1'], 10);
    });

    test('should split pot evenly among multiple winners', () {
      final players = [
        Player.human(id: '1', name: 'P1', chips: 20, position: 0),
        Player.npc(id: '2', name: 'P2', chips: 20, position: 1),
      ];

      final distribution = GameRules.distributePot(
        pot: 10,
        winnerIds: ['1', '2'],
        allPlayers: players,
        openerIndex: 0,
      );

      expect(distribution['1'], 5);
      expect(distribution['2'], 5);
    });

    test('should give odd chip to player closest clockwise to opener', () {
      final players = [
        Player.human(id: '1', name: 'P1', chips: 20, position: 0),
        Player.npc(id: '2', name: 'P2', chips: 20, position: 1),
        Player.npc(id: '3', name: 'P3', chips: 20, position: 2),
      ];

      final distribution = GameRules.distributePot(
        pot: 11,
        winnerIds: ['2', '3'],
        allPlayers: players,
        openerIndex: 0,
      );

      expect(distribution['2'], 6); // Closer to opener (position 1)
      expect(distribution['3'], 5);
    });
  });
}

