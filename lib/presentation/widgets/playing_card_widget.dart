import 'package:flutter/material.dart';
import '../../domain/entities/card.dart' as game;
import '../theme/sudden_death_theme.dart';

class PlayingCardWidget extends StatelessWidget {
  final game.Card? card;
  final bool faceUp;
  final bool selected;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const PlayingCardWidget({
    super.key,
    this.card,
    this.faceUp = true,
    this.selected = false,
    this.onTap,
    this.width = SuddenDeathSizes.cardWidth,
    this.height = SuddenDeathSizes.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    // If card is null, always show back regardless of faceUp
    final shouldShowFace = faceUp && card != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: SuddenDeathAnimations.fast,
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: shouldShowFace ? SuddenDeathGradients.cardFace : SuddenDeathGradients.cardBack,
          borderRadius: BorderRadius.circular(SuddenDeathSizes.cardRadius),
          border: Border.all(
            color: selected ? SuddenDeathColors.gold : Colors.transparent,
            width: selected ? 2 : 0,
          ),
          boxShadow: selected ? SuddenDeathShadows.cardGlow : SuddenDeathShadows.cardShadow,
        ),
        child: shouldShowFace ? _buildCardFace() : _buildCardBack(),
      ),
    );
  }

  Widget _buildCardFace() {
    final cardColor = _getCardColor();
    
    return Stack(
      children: [
        // Top-left corner
        Positioned(
          top: 4,
          left: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getRankSymbol(),
                style: SuddenDeathTextStyles.cardValue.copyWith(
                  color: cardColor,
                  fontSize: 16,
                ),
              ),
              Text(
                _getSuitSymbol(),
                style: SuddenDeathTextStyles.cardSuit.copyWith(
                  color: cardColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        
        // Center suit symbol
        Center(
          child: Text(
            _getSuitSymbol(),
            style: SuddenDeathTextStyles.cardSuit.copyWith(
              color: cardColor.withOpacity(0.3),
              fontSize: 40,
            ),
          ),
        ),
        
        // Bottom-right corner (rotated)
        Positioned(
          bottom: 4,
          right: 6,
          child: Transform.rotate(
            angle: 3.14159, // 180 degrees
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getRankSymbol(),
                  style: SuddenDeathTextStyles.cardValue.copyWith(
                    color: cardColor,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _getSuitSymbol(),
                  style: SuddenDeathTextStyles.cardSuit.copyWith(
                    color: cardColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardBack() {
    return Center(
      child: Icon(
        Icons.casino,
        color: SuddenDeathColors.bloodRed.withOpacity(0.3),
        size: 32,
      ),
    );
  }

  Color _getCardColor() {
    if (card == null) return SuddenDeathColors.bone;
    
    switch (card!.suit) {
      case game.Suit.hearts:
        return SuddenDeathColors.hearts;
      case game.Suit.diamonds:
        return SuddenDeathColors.diamonds;
      case game.Suit.spades:
        return SuddenDeathColors.spades;
      case game.Suit.clubs:
        return SuddenDeathColors.clubs;
    }
  }

  String _getSuitSymbol() {
    if (card == null) return '';
    
    switch (card!.suit) {
      case game.Suit.hearts:
        return '♥';
      case game.Suit.diamonds:
        return '♦';
      case game.Suit.spades:
        return '♠';
      case game.Suit.clubs:
        return '♣';
    }
  }

  String _getRankSymbol() {
    if (card == null) return '';
    
    switch (card!.rank) {
      case game.Rank.ace:
        return 'A';
      case game.Rank.two:
        return '2';
      case game.Rank.three:
        return '3';
      case game.Rank.four:
        return '4';
      case game.Rank.five:
        return '5';
      case game.Rank.six:
        return '6';
      case game.Rank.seven:
        return '7';
      case game.Rank.eight:
        return '8';
      case game.Rank.nine:
        return '9';
      case game.Rank.ten:
        return '10';
      case game.Rank.jack:
        return 'J';
      case game.Rank.queen:
        return 'Q';
      case game.Rank.king:
        return 'K';
    }
  }
}

