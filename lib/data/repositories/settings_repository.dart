import '../datasources/sqlite_datasource.dart';

/// App settings model
class AppSettings {
  final bool soundEnabled;
  final bool hapticsEnabled;
  final String themeId;
  final bool isPremium;

  const AppSettings({
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.themeId = 'default',
    this.isPremium = false,
  });

  AppSettings copyWith({
    bool? soundEnabled,
    bool? hapticsEnabled,
    String? themeId,
    bool? isPremium,
  }) {
    return AppSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      themeId: themeId ?? this.themeId,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

/// Repository for managing app settings
class SettingsRepository {
  final SQLiteDataSource _dataSource;

  SettingsRepository(this._dataSource);

  /// Get current settings
  Future<AppSettings> getSettings() async {
    final soundEnabled = await _dataSource.getSetting('soundEnabled') == 'true';
    final hapticsEnabled = await _dataSource.getSetting('hapticsEnabled') == 'true';
    final themeId = await _dataSource.getSetting('themeId') ?? 'default';
    final isPremium = await _dataSource.getSetting('isPremiumCached') == 'true';

    return AppSettings(
      soundEnabled: soundEnabled,
      hapticsEnabled: hapticsEnabled,
      themeId: themeId,
      isPremium: isPremium,
    );
  }

  /// Toggle sound
  Future<void> toggleSound() async {
    final current = await getSettings();
    await _dataSource.setSetting('soundEnabled', (!current.soundEnabled).toString());
  }

  /// Toggle haptics
  Future<void> toggleHaptics() async {
    final current = await getSettings();
    await _dataSource.setSetting('hapticsEnabled', (!current.hapticsEnabled).toString());
  }

  /// Set theme
  Future<void> setTheme(String themeId) async {
    await _dataSource.setSetting('themeId', themeId);
  }

  /// Mark as premium (after IAP)
  Future<void> setPremium(bool isPremium) async {
    await _dataSource.setSetting('isPremiumCached', isPremium.toString());
  }
}

