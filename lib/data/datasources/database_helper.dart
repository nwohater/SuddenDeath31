import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// SQLite database helper for Sudden Death 31
/// Manages database creation, versioning, and migrations
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('suddendeath31.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // App Settings Table
    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    // Player Profile Table
    await db.execute('''
      CREATE TABLE player_profile (
        id INTEGER PRIMARY KEY,
        career_unlocked INTEGER DEFAULT 1,
        high_stakes_unlocked INTEGER DEFAULT 0,
        selected_cosmetic_set_id TEXT,
        created_at TEXT
      )
    ''');

    // Career State Table
    await db.execute('''
      CREATE TABLE career_state (
        id INTEGER PRIMARY KEY,
        is_active INTEGER DEFAULT 0,
        current_venue_id TEXT,
        chips INTEGER DEFAULT 0,
        hands_remaining INTEGER DEFAULT 0,
        completed_venue_ids TEXT,
        completed_once INTEGER DEFAULT 0
      )
    ''');

    // High Stakes Bankroll Table
    await db.execute('''
      CREATE TABLE high_stakes_bankroll (
        id INTEGER PRIMARY KEY,
        chips INTEGER DEFAULT 100,
        active_loan_count INTEGER DEFAULT 0,
        loan_balance INTEGER DEFAULT 0
      )
    ''');

    // Stats Aggregate Table
    await db.execute('''
      CREATE TABLE stats_aggregate (
        id INTEGER PRIMARY KEY,
        practice_games INTEGER DEFAULT 0,
        career_games INTEGER DEFAULT 0,
        high_stakes_games INTEGER DEFAULT 0,
        total_hands INTEGER DEFAULT 0,
        total_31 INTEGER DEFAULT 0,
        total_blitz INTEGER DEFAULT 0,
        biggest_pot INTEGER DEFAULT 0,
        biggest_comeback INTEGER DEFAULT 0,
        wins_practice INTEGER DEFAULT 0,
        wins_career INTEGER DEFAULT 0,
        wins_high_stakes INTEGER DEFAULT 0
      )
    ''');

    // Game History Table (optional)
    await db.execute('''
      CREATE TABLE game_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mode TEXT,
        timestamp TEXT,
        final_chips INTEGER,
        result TEXT,
        notes TEXT
      )
    ''');

    // Initialize default records
    await _initializeDefaults(db);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here when version changes
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE ...');
    // }
  }

  Future<void> _initializeDefaults(Database db) async {
    // Initialize player profile
    await db.insert('player_profile', {
      'id': 1,
      'career_unlocked': 1,
      'high_stakes_unlocked': 0,
      'selected_cosmetic_set_id': 'default',
      'created_at': DateTime.now().toIso8601String(),
    });

    // Initialize career state
    await db.insert('career_state', {
      'id': 1,
      'is_active': 0,
      'current_venue_id': null,
      'chips': 0,
      'hands_remaining': 0,
      'completed_venue_ids': '[]',
      'completed_once': 0,
    });

    // Initialize high stakes bankroll
    await db.insert('high_stakes_bankroll', {
      'id': 1,
      'chips': 100,
      'active_loan_count': 0,
      'loan_balance': 0,
    });

    // Initialize stats
    await db.insert('stats_aggregate', {
      'id': 1,
    });

    // Initialize default settings
    await db.insert('app_settings', {'key': 'soundEnabled', 'value': 'true'});
    await db.insert('app_settings', {'key': 'hapticsEnabled', 'value': 'true'});
    await db.insert('app_settings', {'key': 'themeId', 'value': 'default'});
    await db.insert('app_settings', {'key': 'isPremiumCached', 'value': 'false'});
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}

