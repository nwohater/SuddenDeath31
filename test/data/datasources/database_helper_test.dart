import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:suddendeath31/data/datasources/database_helper.dart';
import 'package:suddendeath31/data/datasources/sqlite_datasource.dart';

void main() {
  // Initialize FFI for testing
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseHelper Tests', () {
    late SQLiteDataSource dataSource;

    setUp(() {
      dataSource = SQLiteDataSource();
    });

    test('should initialize database with default values', () async {
      final profile = await dataSource.getPlayerProfile();
      expect(profile, isNotNull);
      expect(profile!['career_unlocked'], 1);
      expect(profile['high_stakes_unlocked'], 0);
    });

    test('should get and set app settings', () async {
      await dataSource.setSetting('testKey', 'testValue');
      final value = await dataSource.getSetting('testKey');
      expect(value, 'testValue');
    });

    test('should update player profile', () async {
      await dataSource.updatePlayerProfile({
        'high_stakes_unlocked': 1,
      });
      final profile = await dataSource.getPlayerProfile();
      expect(profile!['high_stakes_unlocked'], 1);
    });

    test('should update career state', () async {
      await dataSource.updateCareerState({
        'is_active': 1,
        'current_venue_id': 'venue_a',
        'chips': 20,
        'hands_remaining': 5,
      });
      final careerState = await dataSource.getCareerState();
      expect(careerState!['is_active'], 1);
      expect(careerState['current_venue_id'], 'venue_a');
      expect(careerState['chips'], 20);
    });

    test('should update high stakes bankroll', () async {
      await dataSource.updateHighStakesBankroll({
        'chips': 150,
        'active_loan_count': 1,
        'loan_balance': 12,
      });
      final bankroll = await dataSource.getHighStakesBankroll();
      expect(bankroll!['chips'], 150);
      expect(bankroll['active_loan_count'], 1);
    });

    test('should increment stats', () async {
      await dataSource.incrementStat('total_31', amount: 1);
      await dataSource.incrementStat('total_blitz', amount: 2);
      
      final stats = await dataSource.getStatsAggregate();
      expect(stats!['total_31'], 1);
      expect(stats['total_blitz'], 2);
    });

    test('should insert and retrieve game history', () async {
      await dataSource.insertGameHistory({
        'mode': 'practice',
        'timestamp': DateTime.now().toIso8601String(),
        'final_chips': 25,
        'result': 'WIN',
        'notes': '{"pot": 10}',
      });

      final history = await dataSource.getGameHistory(mode: 'practice', limit: 1);
      expect(history.length, 1);
      expect(history.first['mode'], 'practice');
      expect(history.first['result'], 'WIN');
    });
  });
}

