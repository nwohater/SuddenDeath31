import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/ai/npc_decision_engine.dart';
import '../../domain/entities/card.dart' as game;
import '../../domain/entities/player.dart';
import '../../domain/usecases/play_turn_usecase.dart';
import '../providers/game_provider.dart';
import '../theme/sudden_death_theme.dart';
import '../widgets/bet_control_widget.dart';
import '../widgets/playing_card_widget.dart';
import '../widgets/player_panel_widget.dart';
import '../widgets/chip_display_widget.dart';

class GameTableScreen extends StatefulWidget {
  const GameTableScreen({super.key});

  @override
  State<GameTableScreen> createState() => _GameTableScreenState();
}

class _GameTableScreenState extends State<GameTableScreen> {
  final NPCDecisionEngine _npcEngine = NPCDecisionEngine();
  game.Card? _selectedCard;
  bool _isProcessingTurn = false;

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
    // Auto-deal cards first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isProcessingTurn) {
        _dealCardsAndShowBetting(context, gameProvider);
      }
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ROUND ${gameProvider.currentGame!.roundNumber + 1}',
            style: SuddenDeathTextStyles.title,
          ),
          const SizedBox(height: SuddenDeathSizes.spacingXl),
          const CircularProgressIndicator(
            color: SuddenDeathColors.crimson,
          ),
        ],
      ),
    );
  }

  void _dealCardsAndShowBetting(BuildContext context, GameProvider gameProvider) {
    setState(() => _isProcessingTurn = true);

    // Deal cards first
    gameProvider.dealCards();

    setState(() => _isProcessingTurn = false);

    // Then show betting dialog
    Future.delayed(const Duration(milliseconds: 500), () {
      _showBettingDialog(context, gameProvider);
    });
  }

  void _showBettingDialog(BuildContext context, GameProvider gameProvider) {
    final players = gameProvider.players;
    final maxBet = players.map((p) => p.chips).reduce((a, b) => a < b ? a : b).clamp(1, 5);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: BetControlWidget(
          minBet: 1,
          maxBet: maxBet,
          initialBet: 1,
          onBetChanged: (bet) {},
          onConfirm: () {
            Navigator.pop(context);
            // Get the bet amount from the widget state
            final betAmount = 1; // TODO: Get from widget
            _startRound(gameProvider, betAmount);
          },
        ),
      ),
    );
  }

  void _startRound(GameProvider gameProvider, int betAmount) {
    setState(() => _isProcessingTurn = true);
    try {
      gameProvider.startRound(betAmount: betAmount);
      // Process NPC turns if needed
      _processNextTurn(gameProvider);
    } finally {
      setState(() => _isProcessingTurn = false);
    }
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
            final isSelected = _selectedCard == card;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: SuddenDeathSizes.spacingXs),
              child: PlayingCardWidget(
                card: card,
                faceUp: true,
                selected: isSelected,
                onTap: isActive && !_isProcessingTurn
                    ? () => _handleCardTap(card)
                    : null,
              ),
            );
          }).toList(),
        ),
        if (isActive && !_isProcessingTurn) ...[
          const SizedBox(height: SuddenDeathSizes.spacingMd),
          _buildActionButtons(),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _selectedCard != null ? _handleDrawAndDiscard : null,
          icon: const Icon(Icons.style),
          label: const Text('DRAW & DISCARD'),
          style: ElevatedButton.styleFrom(
            backgroundColor: SuddenDeathColors.charcoal,
          ),
        ),
        const SizedBox(width: SuddenDeathSizes.spacingMd),
        ElevatedButton.icon(
          onPressed: _selectedCard != null ? _handleSwap : null,
          icon: const Icon(Icons.swap_horiz),
          label: const Text('SWAP'),
          style: ElevatedButton.styleFrom(
            backgroundColor: SuddenDeathColors.crimson,
          ),
        ),
      ],
    );
  }

  void _handleCardTap(game.Card card) {
    setState(() {
      _selectedCard = _selectedCard == card ? null : card;
    });
  }

  void _handleDrawAndDiscard() {
    if (_selectedCard == null) return;
    final gameProvider = context.read<GameProvider>();

    setState(() => _isProcessingTurn = true);
    try {
      gameProvider.playTurn(
        playerId: 'human',
        action: TurnAction.drawAndDiscard,
        cardToDiscard: _selectedCard!,
      );
      _selectedCard = null;
      _processNextTurn(gameProvider);
    } finally {
      setState(() => _isProcessingTurn = false);
    }
  }

  void _handleSwap() {
    if (_selectedCard == null) return;
    final gameProvider = context.read<GameProvider>();
    final round = gameProvider.currentRound;
    if (round == null || round.discardPile.isEmpty) return;

    setState(() => _isProcessingTurn = true);
    try {
      gameProvider.playTurn(
        playerId: 'human',
        action: TurnAction.swapWithDiscard,
        cardToDiscard: round.discardPile.last,
        cardToSwap: _selectedCard!,
      );
      _selectedCard = null;
      _processNextTurn(gameProvider);
    } finally {
      setState(() => _isProcessingTurn = false);
    }
  }

  void _processNextTurn(GameProvider gameProvider) {
    final round = gameProvider.currentRound;
    if (round == null || round.isComplete) return;

    final currentPlayer = round.players[round.currentPlayerIndex];

    // If it's an NPC's turn, process it automatically
    if (currentPlayer.isNPC) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        _processNPCTurn(gameProvider, currentPlayer);
      });
    }
  }

  void _processNPCTurn(GameProvider gameProvider, Player npcPlayer) {
    final round = gameProvider.currentRound;
    if (round == null || _isProcessingTurn) return;

    setState(() => _isProcessingTurn = true);

    try {
      final decision = _npcEngine.decideTurnAction(
        profile: npcPlayer.npcProfile!,
        hand: npcPlayer.hand,
        topDiscard: round.discardPile.last,
        roundState: round,
      );

      gameProvider.playTurn(
        playerId: npcPlayer.id,
        action: decision.turnAction!,
        cardToDiscard: decision.cardToDiscard!,
        cardToSwap: decision.cardToSwap,
      );

      // Continue processing if still NPC turn
      _processNextTurn(gameProvider);
    } finally {
      setState(() => _isProcessingTurn = false);
    }
  }
}

