import 'package:flutter/material.dart';
import '../theme/sudden_death_theme.dart';

class BetControlWidget extends StatefulWidget {
  final int minBet;
  final int maxBet;
  final int initialBet;
  final ValueChanged<int> onBetChanged;
  final VoidCallback onConfirm;

  const BetControlWidget({
    super.key,
    required this.minBet,
    required this.maxBet,
    required this.initialBet,
    required this.onBetChanged,
    required this.onConfirm,
  });

  @override
  State<BetControlWidget> createState() => _BetControlWidgetState();
}

class _BetControlWidgetState extends State<BetControlWidget> {
  late int _currentBet;

  @override
  void initState() {
    super.initState();
    _currentBet = widget.initialBet.clamp(widget.minBet, widget.maxBet);
  }

  void _incrementBet() {
    if (_currentBet < widget.maxBet) {
      setState(() {
        _currentBet++;
        widget.onBetChanged(_currentBet);
      });
    }
  }

  void _decrementBet() {
    if (_currentBet > widget.minBet) {
      setState(() {
        _currentBet--;
        widget.onBetChanged(_currentBet);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SuddenDeathSizes.spacingLg),
      decoration: SuddenDeathDecorations.glassPanel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'PLACE YOUR BET',
            style: SuddenDeathTextStyles.button.copyWith(
              color: SuddenDeathColors.gold,
            ),
          ),
          const SizedBox(height: SuddenDeathSizes.spacingLg),
          
          // Bet amount display
          Container(
            padding: const EdgeInsets.all(SuddenDeathSizes.spacingLg),
            decoration: BoxDecoration(
              gradient: SuddenDeathGradients.goldShimmer,
              borderRadius: BorderRadius.circular(SuddenDeathSizes.radiusMd),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: SuddenDeathColors.abyss,
                  size: 32,
                ),
                const SizedBox(width: SuddenDeathSizes.spacingSm),
                Text(
                  '$_currentBet',
                  style: SuddenDeathTextStyles.score.copyWith(
                    fontSize: 48,
                    color: SuddenDeathColors.abyss,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: SuddenDeathSizes.spacingLg),
          
          // Increment/Decrement buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _BetButton(
                icon: Icons.remove,
                onPressed: _currentBet > widget.minBet ? _decrementBet : null,
              ),
              const SizedBox(width: SuddenDeathSizes.spacingXl),
              _BetButton(
                icon: Icons.add,
                onPressed: _currentBet < widget.maxBet ? _incrementBet : null,
              ),
            ],
          ),
          
          const SizedBox(height: SuddenDeathSizes.spacingLg),
          
          // Confirm button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: SuddenDeathColors.crimson,
                padding: const EdgeInsets.symmetric(vertical: SuddenDeathSizes.spacingLg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SuddenDeathSizes.radiusMd),
                ),
              ),
              child: Text(
                'CONFIRM BET',
                style: SuddenDeathTextStyles.button,
              ),
            ),
          ),
          
          const SizedBox(height: SuddenDeathSizes.spacingSm),
          
          // Min/Max info
          Text(
            'Min: ${widget.minBet} • Max: ${widget.maxBet}',
            style: SuddenDeathTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _BetButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _BetButton({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: onPressed != null
            ? SuddenDeathGradients.buttonDefault
            : null,
        color: onPressed == null ? SuddenDeathColors.shadow : null,
      ),
      child: IconButton(
        icon: Icon(icon),
        iconSize: 32,
        color: onPressed != null ? SuddenDeathColors.bone : SuddenDeathColors.dust,
        onPressed: onPressed,
      ),
    );
  }
}

