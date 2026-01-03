import '../datasources/sqlite_datasource.dart';

/// Player profile model
class PlayerProfile {
  final String playerName;
  final int totalChipsWon;
  final bool careerUnlocked;
  final bool highStakesUnlocked;
  final String selectedCosmeticSetId;
  final DateTime createdAt;

  const PlayerProfile({
    required this.playerName,
    this.totalChipsWon = 0,
    this.careerUnlocked = true,
    this.highStakesUnlocked = false,
    this.selectedCosmeticSetId = 'default',
    required this.createdAt,
  });

  factory PlayerProfile.fromMap(Map<String, dynamic> map) {
    return PlayerProfile(
      playerName: map['player_name'] as String? ?? 'Player',
      totalChipsWon: map['total_chips_won'] as int? ?? 0,
      careerUnlocked: (map['career_unlocked'] as int? ?? 1) == 1,
      highStakesUnlocked: (map['high_stakes_unlocked'] as int? ?? 0) == 1,
      selectedCosmeticSetId: map['selected_cosmetic_set_id'] as String? ?? 'default',
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'player_name': playerName,
      'total_chips_won': totalChipsWon,
      'career_unlocked': careerUnlocked ? 1 : 0,
      'high_stakes_unlocked': highStakesUnlocked ? 1 : 0,
      'selected_cosmetic_set_id': selectedCosmeticSetId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PlayerProfile copyWith({
    String? playerName,
    int? totalChipsWon,
    bool? careerUnlocked,
    bool? highStakesUnlocked,
    String? selectedCosmeticSetId,
  }) {
    return PlayerProfile(
      playerName: playerName ?? this.playerName,
      totalChipsWon: totalChipsWon ?? this.totalChipsWon,
      careerUnlocked: careerUnlocked ?? this.careerUnlocked,
      highStakesUnlocked: highStakesUnlocked ?? this.highStakesUnlocked,
      selectedCosmeticSetId: selectedCosmeticSetId ?? this.selectedCosmeticSetId,
      createdAt: createdAt,
    );
  }
}

/// Repository for managing player profile
class ProfileRepository {
  final SQLiteDataSource _dataSource;

  ProfileRepository(this._dataSource);

  /// Get player profile
  Future<PlayerProfile> getProfile() async {
    final data = await _dataSource.getPlayerProfile();
    if (data == null) {
      // Create default profile
      final defaultProfile = PlayerProfile(
        playerName: 'Player',
        createdAt: DateTime.now(),
      );
      await _saveProfile(defaultProfile);
      return defaultProfile;
    }
    return PlayerProfile.fromMap(data);
  }

  /// Update player name
  Future<void> updatePlayerName(String name) async {
    final profile = await getProfile();
    await _saveProfile(profile.copyWith(playerName: name));
  }

  /// Add chips won
  Future<void> addChipsWon(int chips) async {
    final profile = await getProfile();
    await _saveProfile(profile.copyWith(
      totalChipsWon: profile.totalChipsWon + chips,
    ));
  }

  /// Unlock career mode
  Future<void> unlockCareer() async {
    final profile = await getProfile();
    await _saveProfile(profile.copyWith(careerUnlocked: true));
  }

  /// Unlock high stakes mode
  Future<void> unlockHighStakes() async {
    final profile = await getProfile();
    await _saveProfile(profile.copyWith(highStakesUnlocked: true));
  }

  /// Set selected cosmetic set
  Future<void> setSelectedCosmetic(String cosmeticSetId) async {
    final profile = await getProfile();
    await _saveProfile(profile.copyWith(selectedCosmeticSetId: cosmeticSetId));
  }

  Future<void> _saveProfile(PlayerProfile profile) async {
    await _dataSource.updatePlayerProfile(profile.toMap());
  }
}

