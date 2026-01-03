import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

/// SQLite data source wrapper
/// Provides CRUD operations for all tables
class SQLiteDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // ==================== App Settings ====================

  Future<String?> getSetting(String key) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) return null;
    return result.first['value'] as String?;
  }

  Future<void> setSetting(String key, String value) async {
    final db = await _dbHelper.database;
    await db.insert(
      'app_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ==================== Player Profile ====================

  Future<Map<String, dynamic>?> getPlayerProfile() async {
    final db = await _dbHelper.database;
    final result = await db.query('player_profile', where: 'id = 1');
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<void> updatePlayerProfile(Map<String, dynamic> data) async {
    final db = await _dbHelper.database;
    await db.update(
      'player_profile',
      data,
      where: 'id = 1',
    );
  }

  // ==================== Career State ====================

  Future<Map<String, dynamic>?> getCareerState() async {
    final db = await _dbHelper.database;
    final result = await db.query('career_state', where: 'id = 1');
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<void> updateCareerState(Map<String, dynamic> data) async {
    final db = await _dbHelper.database;
    await db.update(
      'career_state',
      data,
      where: 'id = 1',
    );
  }

  // ==================== High Stakes Bankroll ====================

  Future<Map<String, dynamic>?> getHighStakesBankroll() async {
    final db = await _dbHelper.database;
    final result = await db.query('high_stakes_bankroll', where: 'id = 1');
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<void> updateHighStakesBankroll(Map<String, dynamic> data) async {
    final db = await _dbHelper.database;
    await db.update(
      'high_stakes_bankroll',
      data,
      where: 'id = 1',
    );
  }

  // ==================== Stats Aggregate ====================

  Future<Map<String, dynamic>?> getStatsAggregate() async {
    final db = await _dbHelper.database;
    final result = await db.query('stats_aggregate', where: 'id = 1');
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<void> updateStatsAggregate(Map<String, dynamic> data) async {
    final db = await _dbHelper.database;
    await db.update(
      'stats_aggregate',
      data,
      where: 'id = 1',
    );
  }

  Future<void> incrementStat(String column, {int amount = 1}) async {
    final db = await _dbHelper.database;
    await db.rawUpdate(
      'UPDATE stats_aggregate SET $column = $column + ? WHERE id = 1',
      [amount],
    );
  }

  // ==================== Game History ====================

  Future<int> insertGameHistory(Map<String, dynamic> data) async {
    final db = await _dbHelper.database;
    return await db.insert('game_history', data);
  }

  Future<List<Map<String, dynamic>>> getGameHistory({
    String? mode,
    int? limit,
  }) async {
    final db = await _dbHelper.database;
    String? where;
    List<dynamic>? whereArgs;

    if (mode != null) {
      where = 'mode = ?';
      whereArgs = [mode];
    }

    return await db.query(
      'game_history',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'timestamp DESC',
      limit: limit,
    );
  }

  // ==================== Utility ====================

  Future<void> resetDatabase() async {
    final db = await _dbHelper.database;
    await db.delete('player_profile');
    await db.delete('career_state');
    await db.delete('high_stakes_bankroll');
    await db.delete('stats_aggregate');
    await db.delete('game_history');
    await db.delete('app_settings');

    // Re-initialize defaults manually
    await db.insert('player_profile', {
      'id': 1,
      'career_unlocked': 1,
      'high_stakes_unlocked': 0,
      'selected_cosmetic_set_id': 'default',
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('career_state', {
      'id': 1,
      'is_active': 0,
      'current_venue_id': null,
      'chips': 0,
      'hands_remaining': 0,
      'completed_venue_ids': '[]',
      'completed_once': 0,
    });

    await db.insert('high_stakes_bankroll', {
      'id': 1,
      'chips': 100,
      'active_loan_count': 0,
      'loan_balance': 0,
    });

    await db.insert('stats_aggregate', {
      'id': 1,
    });

    await db.insert('app_settings', {'key': 'soundEnabled', 'value': 'true'});
    await db.insert('app_settings', {'key': 'hapticsEnabled', 'value': 'true'});
    await db.insert('app_settings', {'key': 'themeId', 'value': 'default'});
    await db.insert('app_settings', {'key': 'isPremiumCached', 'value': 'false'});
  }
}

