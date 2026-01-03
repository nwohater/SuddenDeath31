import 'package:flutter/material.dart';
import '../theme/sudden_death_theme.dart';

class ChipDisplayWidget extends StatelessWidget {
  final int amount;
  final String label;
  final bool large;

  const ChipDisplayWidget({
    super.key,
    required this.amount,
    this.label = 'CHIPS',
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(large ? SuddenDeathSizes.spacingLg : SuddenDeathSizes.spacingMd),
      decoration: SuddenDeathDecorations.glassPanel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on,
            color: SuddenDeathColors.gold,
            size: large ? 32 : 24,
          ),
          SizedBox(height: large ? SuddenDeathSizes.spacingSm : SuddenDeathSizes.spacingXs),
          Text(
            '$amount',
            style: large
                ? SuddenDeathTextStyles.score.copyWith(fontSize: 32)
                : SuddenDeathTextStyles.button.copyWith(fontSize: 20),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: SuddenDeathSizes.spacingXs),
            Text(
              label,
              style: SuddenDeathTextStyles.caption,
            ),
          ],
        ],
      ),
    );
  }
}

class PotDisplayWidget extends StatelessWidget {
  final int amount;

  const PotDisplayWidget({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SuddenDeathSizes.spacingLg,
        vertical: SuddenDeathSizes.spacingMd,
      ),
      decoration: BoxDecoration(
        gradient: SuddenDeathGradients.goldShimmer,
        borderRadius: BorderRadius.circular(SuddenDeathSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: SuddenDeathColors.gold.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'POT',
            style: SuddenDeathTextStyles.caption.copyWith(
              color: SuddenDeathColors.abyss,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SuddenDeathSizes.spacingXs),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.monetization_on,
                color: SuddenDeathColors.abyss,
                size: 24,
              ),
              const SizedBox(width: SuddenDeathSizes.spacingXs),
              Text(
                '$amount',
                style: SuddenDeathTextStyles.score.copyWith(
                  fontSize: 28,
                  color: SuddenDeathColors.abyss,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

