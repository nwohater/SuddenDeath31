import 'package:flutter/foundation.dart';
import '../../data/repositories/settings_repository.dart';

/// Provider for managing app settings
class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;
  String _themeId = 'default';
  bool _isPremium = false;
  bool _isLoading = false;

  SettingsProvider({required SettingsRepository settingsRepository})
      : _settingsRepository = settingsRepository {
    _loadSettings();
  }

  bool get soundEnabled => _soundEnabled;
  bool get hapticsEnabled => _hapticsEnabled;
  String get themeId => _themeId;
  bool get isPremium => _isPremium;
  bool get isLoading => _isLoading;

  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final settings = await _settingsRepository.getSettings();
      _soundEnabled = settings.soundEnabled;
      _hapticsEnabled = settings.hapticsEnabled;
      _themeId = settings.themeId;
      _isPremium = settings.isPremium;
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleSound() async {
    await _settingsRepository.toggleSound();
    _soundEnabled = !_soundEnabled;
    notifyListeners();
  }

  Future<void> toggleHaptics() async {
    await _settingsRepository.toggleHaptics();
    _hapticsEnabled = !_hapticsEnabled;
    notifyListeners();
  }

  Future<void> setTheme(String themeId) async {
    await _settingsRepository.setTheme(themeId);
    _themeId = themeId;
    notifyListeners();
  }

  Future<void> setPremium(bool isPremium) async {
    await _settingsRepository.setPremium(isPremium);
    _isPremium = isPremium;
    notifyListeners();
  }
}

