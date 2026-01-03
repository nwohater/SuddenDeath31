import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stats_provider.dart';
import '../theme/sudden_death_theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: SuddenDeathGradients.backgroundLinear,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildStats(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SuddenDeathSizes.spacingLg),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: SuddenDeathColors.bone),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: SuddenDeathSizes.spacingMd),
          Text(
            'STATISTICS',
            style: SuddenDeathTextStyles.title.copyWith(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Consumer<StatsProvider>(
      builder: (context, stats, child) {
        if (stats.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: SuddenDeathColors.crimson,
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(SuddenDeathSizes.spacingLg),
          children: [
            _buildHighlightStats(stats),
            const SizedBox(height: SuddenDeathSizes.spacingXl),
            _buildSection(
              title: 'PERFORMANCE',
              children: [
                _StatTile(label: 'Hands Played', value: '${stats.totalHandsPlayed}'),
                _StatTile(label: 'Rounds Won', value: '${stats.totalRoundsWon}'),
                _StatTile(
                  label: 'Win Rate',
                  value: '${(stats.winRate * 100).toStringAsFixed(1)}%',
                  highlight: true,
                ),
              ],
            ),
            const SizedBox(height: SuddenDeathSizes.spacingXl),
            _buildSection(
              title: 'CHIPS',
              children: [
                _StatTile(label: 'Total Won', value: '${stats.totalChipsWon}'),
                _StatTile(label: 'Total Lost', value: '${stats.totalChipsLost}'),
                _StatTile(
                  label: 'Net Chips',
                  value: '${stats.netChips >= 0 ? '+' : ''}${stats.netChips}',
                  highlight: true,
                  valueColor: stats.netChips >= 0
                      ? SuddenDeathColors.success
                      : SuddenDeathColors.danger,
                ),
                _StatTile(
                  label: 'Highest Pot',
                  value: '${stats.highestPotWon}',
                  highlight: true,
                ),
              ],
            ),
            const SizedBox(height: SuddenDeathSizes.spacingXl),
            _buildSection(
              title: 'ACHIEVEMENTS',
              children: [
                _StatTile(label: 'Instant Wins (31)', value: '${stats.instantWins31}'),
                _StatTile(label: 'Instant Wins (Blitz)', value: '${stats.instantWinsBlitz}'),
                _StatTile(label: 'Career Completions', value: '${stats.careerCompletions}'),
                _StatTile(label: 'High Stakes Sessions', value: '${stats.highStakesSessions}'),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildHighlightStats(StatsProvider stats) {
    return Row(
      children: [
        Expanded(
          child: _HighlightCard(
            label: 'HANDS',
            value: '${stats.totalHandsPlayed}',
            icon: Icons.style,
          ),
        ),
        const SizedBox(width: SuddenDeathSizes.spacingMd),
        Expanded(
          child: _HighlightCard(
            label: 'WINS',
            value: '${stats.totalRoundsWon}',
            icon: Icons.emoji_events,
          ),
        ),
        const SizedBox(width: SuddenDeathSizes.spacingMd),
        Expanded(
          child: _HighlightCard(
            label: 'WIN %',
            value: '${(stats.winRate * 100).toStringAsFixed(0)}',
            icon: Icons.trending_up,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: SuddenDeathSizes.spacingMd),
          child: Text(
            title,
            style: SuddenDeathTextStyles.button.copyWith(
              color: SuddenDeathColors.gold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: SuddenDeathSizes.spacingSm),
        Container(
          decoration: SuddenDeathDecorations.glassPanel,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _HighlightCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SuddenDeathSizes.spacingMd),
      decoration: SuddenDeathDecorations.glassPanel,
      child: Column(
        children: [
          Icon(icon, color: SuddenDeathColors.crimson, size: 32),
          const SizedBox(height: SuddenDeathSizes.spacingSm),
          Text(value, style: SuddenDeathTextStyles.score.copyWith(fontSize: 24)),
          Text(label, style: SuddenDeathTextStyles.caption),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final Color? valueColor;

  const _StatTile({
    required this.label,
    required this.value,
    this.highlight = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SuddenDeathSizes.spacingLg,
        vertical: SuddenDeathSizes.spacingMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: SuddenDeathTextStyles.body),
          Text(
            value,
            style: highlight
                ? SuddenDeathTextStyles.button.copyWith(
                    color: valueColor ?? SuddenDeathColors.gold,
                  )
                : SuddenDeathTextStyles.body.copyWith(
                    color: valueColor ?? SuddenDeathColors.ash,
                  ),
          ),
        ],
      ),
    );
  }
}

