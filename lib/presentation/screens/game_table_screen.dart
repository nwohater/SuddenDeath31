import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/player.dart';
import '../providers/game_provider.dart';
import '../theme/sudden_death_theme.dart';
import '../widgets/playing_card_widget.dart';
import '../widgets/player_panel_widget.dart';
import '../widgets/chip_display_widget.dart';

class GameTableScreen extends StatelessWidget {
  const GameTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: SuddenDeathGradients.backgroundRadial,
        ),
        child: SafeArea(
          child: Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              if (!gameProvider.hasActiveGame) {
                return _buildNoGameView(context);
              }

              final currentRound = gameProvider.currentRound;
              if (currentRound == null) {
                return _buildBetweenRoundsView(context, gameProvider);
              }

              return _buildGameView(context, gameProvider);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNoGameView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'NO ACTIVE GAME',
            style: SuddenDeathTextStyles.title,
          ),
          const SizedBox(height: SuddenDeathSizes.spacingXl),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BACK TO MENU'),
          ),
        ],
      ),
    );
  }

  Widget _buildBetweenRoundsView(BuildContext context, GameProvider gameProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ROUND ${gameProvider.currentGame!.roundNumber}',
            style: SuddenDeathTextStyles.title,
          ),
          const SizedBox(height: SuddenDeathSizes.spacingXl),
          Text(
            'Ready for next round?',
            style: SuddenDeathTextStyles.body,
          ),
          const SizedBox(height: SuddenDeathSizes.spacingXl),
          ElevatedButton(
            onPressed: () {
              // TODO: Show bet selection dialog
            },
            child: const Text('START ROUND'),
          ),
        ],
      ),
    );
  }

  Widget _buildGameView(BuildContext context, GameProvider gameProvider) {
    final round = gameProvider.currentRound!;
    final players = round.players;
    final currentPlayerIndex = round.currentPlayerIndex;
    final humanPlayer = players.first; // Assume first player is human

    return Stack(
      children: [
        Column(
          children: [
            // Top bar with round info
            _buildTopBar(round),
            
            const Spacer(),
            
            // Opponent players (top of screen)
            _buildOpponentPlayers(players.sublist(1)),
            
            const Spacer(),
            
            // Center area with deck and discard pile
            _buildCenterArea(round),
            
            const Spacer(),
            
            // Human player's hand (bottom of screen)
            _buildHumanPlayerArea(humanPlayer, currentPlayerIndex == 0),
            
            const SizedBox(height: SuddenDeathSizes.spacingLg),
          ],
        ),
        
        // Back button
        Positioned(
          top: SuddenDeathSizes.spacingMd,
          left: SuddenDeathSizes.spacingMd,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: SuddenDeathColors.bone),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(round) {
    return Padding(
      padding: const EdgeInsets.all(SuddenDeathSizes.spacingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ChipDisplayWidget(
            amount: round.pot,
            label: 'POT',
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SuddenDeathSizes.spacingLg,
              vertical: SuddenDeathSizes.spacingMd,
            ),
            decoration: SuddenDeathDecorations.glassPanel,
            child: Column(
              children: [
                Text(
                  'TURNS LEFT',
                  style: SuddenDeathTextStyles.caption,
                ),
                Text(
                  '${round.turnsRemaining}',
                  style: SuddenDeathTextStyles.score.copyWith(fontSize: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpponentPlayers(List<Player> opponents) {
    return Wrap(
      spacing: SuddenDeathSizes.spacingMd,
      children: opponents.map((player) {
        return PlayerPanelWidget(player: player);
      }).toList(),
    );
  }

  Widget _buildCenterArea(round) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Deck
        const PlayingCardWidget(faceUp: false),
        const SizedBox(width: SuddenDeathSizes.spacingXl),
        // Discard pile
        PlayingCardWidget(
          card: round.discardPile.isNotEmpty ? round.discardPile.last : null,
          faceUp: true,
        ),
      ],
    );
  }

  Widget _buildHumanPlayerArea(Player player, bool isActive) {
    return Column(
      children: [
        PlayerPanelWidget(player: player, isActive: isActive),
        const SizedBox(height: SuddenDeathSizes.spacingMd),
        // Player's cards
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: player.hand.cards.map((card) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: SuddenDeathSizes.spacingXs),
              child: PlayingCardWidget(
                card: card,
                faceUp: true,
                onTap: () {
                  // TODO: Handle card selection
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

