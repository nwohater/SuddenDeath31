import 'package:flutter/material.dart';
import '../../domain/entities/player.dart';
import '../theme/sudden_death_theme.dart';

class PlayerPanelWidget extends StatelessWidget {
  final Player player;
  final bool isActive;
  final bool isDealer;

  const PlayerPanelWidget({
    super.key,
    required this.player,
    this.isActive = false,
    this.isDealer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SuddenDeathSizes.spacingMd),
      decoration: isActive
          ? SuddenDeathDecorations.activePlayerPanel
          : SuddenDeathDecorations.glassPanel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Player name
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDealer) ...[
                const Icon(
                  Icons.stars,
                  color: SuddenDeathColors.gold,
                  size: 16,
                ),
                const SizedBox(width: SuddenDeathSizes.spacingXs),
              ],
              Flexible(
                child: Text(
                  player.name,
                  style: SuddenDeathTextStyles.playerName.copyWith(
                    color: isActive ? SuddenDeathColors.bone : SuddenDeathColors.ash,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: SuddenDeathSizes.spacingSm),
          
          // Chip count
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SuddenDeathSizes.spacingSm,
              vertical: SuddenDeathSizes.spacingXs,
            ),
            decoration: BoxDecoration(
              color: SuddenDeathColors.abyss.withOpacity(0.5),
              borderRadius: BorderRadius.circular(SuddenDeathSizes.radiusSm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: SuddenDeathColors.gold,
                  size: 14,
                ),
                const SizedBox(width: SuddenDeathSizes.spacingXs),
                Text(
                  '${player.chips}',
                  style: SuddenDeathTextStyles.button.copyWith(
                    fontSize: 14,
                    color: SuddenDeathColors.gold,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: SuddenDeathSizes.spacingSm),
          
          // Hand score (if visible)
          if (player.hand.cards.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SuddenDeathSizes.spacingSm,
                vertical: SuddenDeathSizes.spacingXs,
              ),
              decoration: BoxDecoration(
                gradient: SuddenDeathGradients.goldShimmer,
                borderRadius: BorderRadius.circular(SuddenDeathSizes.radiusSm),
              ),
              child: Text(
                '${player.hand.score}',
                style: SuddenDeathTextStyles.button.copyWith(
                  fontSize: 16,
                  color: SuddenDeathColors.abyss,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

