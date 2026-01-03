import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/datasources/sqlite_datasource.dart';
import 'data/repositories/game_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/repositories/stats_repository.dart';
import 'domain/usecases/check_game_over_usecase.dart';
import 'domain/usecases/deal_initial_hands_usecase.dart';
import 'domain/usecases/play_turn_usecase.dart';
import 'domain/usecases/resolve_round_usecase.dart';
import 'domain/usecases/validate_bet_usecase.dart';
import 'presentation/providers/game_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/stats_provider.dart';
import 'presentation/screens/main_menu_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/stats_screen.dart';
import 'presentation/theme/sudden_death_theme.dart';

void main() {
  runApp(const SuddenDeath31App());
}

class SuddenDeath31App extends StatelessWidget {
  const SuddenDeath31App({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize dependencies
    final sqliteDataSource = SQLiteDataSource();
    final gameRepository = GameRepository();
    final settingsRepository = SettingsRepository(sqliteDataSource);
    final statsRepository = StatsRepository(sqliteDataSource);

    // Initialize use cases
    final dealInitialHandsUseCase = DealInitialHandsUseCase();
    final playTurnUseCase = PlayTurnUseCase();
    final resolveRoundUseCase = ResolveRoundUseCase();
    final checkGameOverUseCase = CheckGameOverUseCase();
    final validateBetUseCase = ValidateBetUseCase();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GameProvider(
            gameRepository: gameRepository,
            dealInitialHandsUseCase: dealInitialHandsUseCase,
            playTurnUseCase: playTurnUseCase,
            resolveRoundUseCase: resolveRoundUseCase,
            checkGameOverUseCase: checkGameOverUseCase,
            validateBetUseCase: validateBetUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(settingsRepository: settingsRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => StatsProvider(statsRepository: statsRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Sudden Death 31',
        theme: SuddenDeathTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const MainMenuScreen(),
        routes: {
          '/settings': (context) => const SettingsScreen(),
          '/stats': (context) => const StatsScreen(),
        },
      ),
    );
  }
}
