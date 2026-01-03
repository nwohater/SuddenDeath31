import 'package:flutter/material.dart';
import '../theme/sudden_death_theme.dart';

/// Unified top bar showing POT, TURNS LEFT, and ROUND in one widget
class GameInfoBarWidget extends StatelessWidget {
  final int pot;
  final int turnsLeft;
  final int currentRound;
  final int totalRounds;

  const GameInfoBarWidget({
    super.key,
    required this.pot,
    required this.turnsLeft,
    required this.currentRound,
    required this.totalRounds,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            SuddenDeathColors.charcoal.withOpacity(0.8),
            SuddenDeathColors.abyss.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(SuddenDeathSizes.radiusLg),
        border: Border.all(
          color: SuddenDeathColors.gold.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // POT section
            _buildSection(
              icon: Icons.monetization_on,
              label: 'POT',
              value: '$pot',
              iconColor: SuddenDeathColors.gold,
            ),
            
            // Divider
            _buildDivider(),
            
            // TURNS LEFT section
            _buildSection(
              icon: Icons.timer_outlined,
              label: 'TURNS LEFT',
              value: '$turnsLeft',
              iconColor: SuddenDeathColors.crimson,
            ),
            
            // Divider
            _buildDivider(),
            
            // ROUND section
            _buildSection(
              icon: Icons.casino_outlined,
              label: 'ROUND',
              value: '$currentRound/$totalRounds',
              iconColor: SuddenDeathColors.bone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SuddenDeathSizes.spacingLg,
        vertical: SuddenDeathSizes.spacingMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: iconColor.withOpacity(0.7),
              ),
              const SizedBox(width: SuddenDeathSizes.spacingXs),
              Text(
                label,
                style: SuddenDeathTextStyles.caption.copyWith(
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: SuddenDeathTextStyles.score.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(vertical: SuddenDeathSizes.spacingSm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            SuddenDeathColors.gold.withOpacity(0.0),
            SuddenDeathColors.gold.withOpacity(0.3),
            SuddenDeathColors.gold.withOpacity(0.0),
          ],
        ),
      ),
    );
  }
}

