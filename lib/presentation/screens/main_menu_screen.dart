import 'package:flutter/material.dart';
import '../theme/sudden_death_theme.dart';
import 'practice_setup_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: SuddenDeathGradients.backgroundRadial,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              
              // Title
              _buildTitle(),
              
              const SizedBox(height: SuddenDeathSizes.spacingXl),
              
              // Menu buttons
              _buildMenuButtons(context),
              
              const Spacer(),
              
              // Version info
              _buildVersionInfo(),
              
              const SizedBox(height: SuddenDeathSizes.spacingLg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'SUDDEN DEATH',
          style: SuddenDeathTextStyles.title.copyWith(
            fontSize: 36,
            letterSpacing: 6,
          ),
        ),
        const SizedBox(height: SuddenDeathSizes.spacingSm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SuddenDeathSizes.spacingMd,
            vertical: SuddenDeathSizes.spacingSm,
          ),
          decoration: BoxDecoration(
            gradient: SuddenDeathGradients.goldShimmer,
            borderRadius: BorderRadius.circular(SuddenDeathSizes.radiusSm),
          ),
          child: Text(
            '31',
            style: SuddenDeathTextStyles.score.copyWith(
              fontSize: 48,
              color: SuddenDeathColors.abyss,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SuddenDeathSizes.spacingXl),
      child: Column(
        children: [
          _MenuButton(
            label: 'PRACTICE',
            gradient: SuddenDeathGradients.buttonDefault,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PracticeSetupScreen()),
              );
            },
          ),
          const SizedBox(height: SuddenDeathSizes.spacingMd),
          _MenuButton(
            label: 'CAREER',
            gradient: SuddenDeathGradients.buttonDefault,
            onPressed: () {
              // TODO: Navigate to career mode
            },
          ),
          const SizedBox(height: SuddenDeathSizes.spacingMd),
          _MenuButton(
            label: 'HIGH STAKES',
            gradient: SuddenDeathGradients.buttonDanger,
            onPressed: () {
              // TODO: Navigate to high stakes mode
            },
          ),
          const SizedBox(height: SuddenDeathSizes.spacingXl),
          Row(
            children: [
              Expanded(
                child: _MenuButton(
                  label: 'STATS',
                  gradient: SuddenDeathGradients.buttonDefault,
                  compact: true,
                  onPressed: () {
                    Navigator.pushNamed(context, '/stats');
                  },
                ),
              ),
              const SizedBox(width: SuddenDeathSizes.spacingMd),
              Expanded(
                child: _MenuButton(
                  label: 'SETTINGS',
                  gradient: SuddenDeathGradients.buttonDefault,
                  compact: true,
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Text(
      'v1.0.0',
      style: SuddenDeathTextStyles.caption,
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final Gradient gradient;
  final VoidCallback onPressed;
  final bool compact;

  const _MenuButton({
    required this.label,
    required this.gradient,
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(SuddenDeathSizes.radiusMd),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: compact ? SuddenDeathSizes.spacingMd : SuddenDeathSizes.spacingLg,
          ),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(SuddenDeathSizes.radiusMd),
            border: Border.all(
              color: SuddenDeathColors.shadow,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: SuddenDeathTextStyles.button,
            ),
          ),
        ),
      ),
    );
  }
}

