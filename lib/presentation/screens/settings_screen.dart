import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/sudden_death_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                child: _buildSettings(context),
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
            'SETTINGS',
            style: SuddenDeathTextStyles.title.copyWith(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return ListView(
          padding: const EdgeInsets.all(SuddenDeathSizes.spacingLg),
          children: [
            _buildSection(
              title: 'AUDIO',
              children: [
                _SettingTile(
                  label: 'Sound Effects',
                  value: settings.soundEnabled,
                  onChanged: (value) => settings.toggleSound(),
                ),
                _SettingTile(
                  label: 'Haptic Feedback',
                  value: settings.hapticsEnabled,
                  onChanged: (value) => settings.toggleHaptics(),
                ),
              ],
            ),
            const SizedBox(height: SuddenDeathSizes.spacingXl),
            _buildSection(
              title: 'PREMIUM',
              children: [
                _buildPremiumStatus(settings.isPremium),
              ],
            ),
            const SizedBox(height: SuddenDeathSizes.spacingXl),
            _buildSection(
              title: 'ABOUT',
              children: [
                _buildInfoTile('Version', '1.0.0'),
                _buildInfoTile('Developer', 'Your Studio'),
              ],
            ),
          ],
        );
      },
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

  Widget _buildPremiumStatus(bool isPremium) {
    return Padding(
      padding: const EdgeInsets.all(SuddenDeathSizes.spacingLg),
      child: Column(
        children: [
          Icon(
            isPremium ? Icons.check_circle : Icons.lock,
            color: isPremium ? SuddenDeathColors.success : SuddenDeathColors.gold,
            size: 48,
          ),
          const SizedBox(height: SuddenDeathSizes.spacingMd),
          Text(
            isPremium ? 'Premium Active' : 'Remove Ads',
            style: SuddenDeathTextStyles.button,
          ),
          if (!isPremium) ...[
            const SizedBox(height: SuddenDeathSizes.spacingSm),
            Text(
              'Support development and remove all ads',
              style: SuddenDeathTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SuddenDeathSizes.spacingLg,
        vertical: SuddenDeathSizes.spacingMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: SuddenDeathTextStyles.body),
          Text(value, style: SuddenDeathTextStyles.caption),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SuddenDeathSizes.spacingLg,
            vertical: SuddenDeathSizes.spacingMd,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: SuddenDeathTextStyles.body),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: SuddenDeathColors.crimson,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

