import '../datasources/sqlite_datasource.dart';

/// Stats model
class GameStats {
  final int totalHandsPlayed;
  final int totalRoundsWon;
  final int totalChipsWon;
  final int totalChipsLost;
  final int instantWins31;
  final int instantWinsBlitz;
  final int highestPotWon;
  final int careerCompletions;
  final int highStakesSessions;

  const GameStats({
    this.totalHandsPlayed = 0,
    this.totalRoundsWon = 0,
    this.totalChipsWon = 0,
    this.totalChipsLost = 0,
    this.instantWins31 = 0,
    this.instantWinsBlitz = 0,
    this.highestPotWon = 0,
    this.careerCompletions = 0,
    this.highStakesSessions = 0,
  });

  factory GameStats.fromMap(Map<String, dynamic> map) {
    return GameStats(
      totalHandsPlayed: map['total_hands_played'] as int? ?? 0,
      totalRoundsWon: map['total_rounds_won'] as int? ?? 0,
      totalChipsWon: map['total_chips_won'] as int? ?? 0,
      totalChipsLost: map['total_chips_lost'] as int? ?? 0,
      instantWins31: map['instant_wins_31'] as int? ?? 0,
      instantWinsBlitz: map['instant_wins_blitz'] as int? ?? 0,
      highestPotWon: map['highest_pot_won'] as int? ?? 0,
      careerCompletions: map['career_completions'] as int? ?? 0,
      highStakesSessions: map['high_stakes_sessions'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_hands_played': totalHandsPlayed,
      'total_rounds_won': totalRoundsWon,
      'total_chips_won': totalChipsWon,
      'total_chips_lost': totalChipsLost,
      'instant_wins_31': instantWins31,
      'instant_wins_blitz': instantWinsBlitz,
      'highest_pot_won': highestPotWon,
      'career_completions': careerCompletions,
      'high_stakes_sessions': highStakesSessions,
    };
  }

  double get winRate {
    if (totalHandsPlayed == 0) return 0.0;
    return totalRoundsWon / totalHandsPlayed;
  }

  int get netChips => totalChipsWon - totalChipsLost;
}

/// Repository for managing game statistics
class StatsRepository {
  final SQLiteDataSource _dataSource;

  StatsRepository(this._dataSource);

  /// Get current stats
  Future<GameStats> getStats() async {
    final data = await _dataSource.getStatsAggregate();
    if (data == null) {
      return const GameStats();
    }
    return GameStats.fromMap(data);
  }

  /// Record a hand played
  Future<void> recordHandPlayed() async {
    await _dataSource.incrementStat('total_hands_played');
  }

  /// Record a round won
  Future<void> recordRoundWon(int chipsWon) async {
    await _dataSource.incrementStat('total_rounds_won');
    await _dataSource.incrementStat('total_chips_won', amount: chipsWon);
    
    // Update highest pot if needed
    final stats = await getStats();
    if (chipsWon > stats.highestPotWon) {
      final data = await _dataSource.getStatsAggregate();
      if (data != null) {
        data['highest_pot_won'] = chipsWon;
        await _dataSource.updateStatsAggregate(data);
      }
    }
  }

  /// Record chips lost
  Future<void> recordChipsLost(int chipsLost) async {
    await _dataSource.incrementStat('total_chips_lost', amount: chipsLost);
  }

  /// Record instant win (31)
  Future<void> recordInstantWin31() async {
    await _dataSource.incrementStat('instant_wins_31');
  }

  /// Record instant win (Blitz)
  Future<void> recordInstantWinBlitz() async {
    await _dataSource.incrementStat('instant_wins_blitz');
  }

  /// Record career completion
  Future<void> recordCareerCompletion() async {
    await _dataSource.incrementStat('career_completions');
  }

  /// Record high stakes session
  Future<void> recordHighStakesSession() async {
    await _dataSource.incrementStat('high_stakes_sessions');
  }

  /// Record game in history
  Future<void> recordGameHistory({
    required String gameMode,
    String? venueName,
    required int roundsPlayed,
    required int chipsWon,
    required int chipsLost,
    required String result,
  }) async {
    await _dataSource.insertGameHistory({
      'mode': gameMode,
      'venue_name': venueName,
      'rounds_played': roundsPlayed,
      'chips_won': chipsWon,
      'chips_lost': chipsLost,
      'result': result,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Get game history
  Future<List<Map<String, dynamic>>> getGameHistory({
    String? mode,
    int? limit,
  }) async {
    return await _dataSource.getGameHistory(mode: mode, limit: limit);
  }
}

