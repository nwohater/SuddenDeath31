import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/hand.dart';
import '../../domain/entities/npc_characters.dart';
import '../../domain/entities/player.dart';
import '../providers/game_provider.dart';
import '../theme/sudden_death_theme.dart';
import 'game_table_screen.dart';

class PracticeSetupScreen extends StatefulWidget {
  const PracticeSetupScreen({super.key});

  @override
  State<PracticeSetupScreen> createState() => _PracticeSetupScreenState();
}

class _PracticeSetupScreenState extends State<PracticeSetupScreen> {
  int _numOpponents = 2;
  int _startingChips = 10;

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
                child: _buildSetupOptions(),
              ),
              _buildStartButton(context),
              const SizedBox(height: SuddenDeathSizes.spacingLg),
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
            'PRACTICE GAME',
            style: SuddenDeathTextStyles.title.copyWith(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupOptions() {
    return ListView(
      padding: const EdgeInsets.all(SuddenDeathSizes.spacingLg),
      children: [
        _buildOptionCard(
          title: 'Number of Opponents',
          value: '$_numOpponents',
          onDecrease: _numOpponents > 1 ? () => setState(() => _numOpponents--) : null,
          onIncrease: _numOpponents < 5 ? () => setState(() => _numOpponents++) : null,
        ),
        const SizedBox(height: SuddenDeathSizes.spacingMd),
        _buildOptionCard(
          title: 'Starting Chips',
          value: '$_startingChips',
          onDecrease: _startingChips > 5 ? () => setState(() => _startingChips -= 5) : null,
          onIncrease: _startingChips < 50 ? () => setState(() => _startingChips += 5) : null,
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String value,
    VoidCallback? onDecrease,
    VoidCallback? onIncrease,
  }) {
    return Container(
      padding: const EdgeInsets.all(SuddenDeathSizes.spacingLg),
      decoration: SuddenDeathDecorations.glassPanel,
      child: Column(
        children: [
          Text(title, style: SuddenDeathTextStyles.button),
          const SizedBox(height: SuddenDeathSizes.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: onDecrease != null ? SuddenDeathColors.crimson : SuddenDeathColors.dust,
                iconSize: 32,
                onPressed: onDecrease,
              ),
              const SizedBox(width: SuddenDeathSizes.spacingXl),
              Text(
                value,
                style: SuddenDeathTextStyles.score.copyWith(fontSize: 32),
              ),
              const SizedBox(width: SuddenDeathSizes.spacingXl),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: onIncrease != null ? SuddenDeathColors.crimson : SuddenDeathColors.dust,
                iconSize: 32,
                onPressed: onIncrease,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SuddenDeathSizes.spacingXl),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _startGame(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: SuddenDeathColors.crimson,
            padding: const EdgeInsets.symmetric(vertical: SuddenDeathSizes.spacingLg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SuddenDeathSizes.radiusMd),
            ),
          ),
          child: Text(
            'START GAME',
            style: SuddenDeathTextStyles.button.copyWith(fontSize: 18),
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context) {
    final gameProvider = context.read<GameProvider>();

    // Create human player
    final humanPlayer = Player.human(
      id: 'human',
      name: 'You',
      chips: _startingChips,
      position: 0,
    );

    // Create NPC players
    final allNPCs = NPCCharacters.allNPCs;
    final selectedNPCs = <Player>[];
    for (int i = 0; i < _numOpponents; i++) {
      final npc = allNPCs[i % allNPCs.length];
      selectedNPCs.add(Player.npc(
        id: npc.id,
        name: npc.name,
        chips: _startingChips,
        position: i + 1,
        profile: npc,
      ));
    }

    // Start the game
    final players = [humanPlayer, ...selectedNPCs];
    gameProvider.startGame(players: players, mode: GameMode.practice);

    // Navigate to game table
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GameTableScreen()),
    );
  }
}

