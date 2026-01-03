import 'package:flutter/foundation.dart';
import '../../data/repositories/stats_repository.dart';

/// Provider for managing game statistics
class StatsProvider extends ChangeNotifier {
  final StatsRepository _statsRepository;
  
  int _totalHandsPlayed = 0;
  int _totalRoundsWon = 0;
  int _totalChipsWon = 0;
  int _totalChipsLost = 0;
  int _instantWins31 = 0;
  int _instantWinsBlitz = 0;
  int _highestPotWon = 0;
  int _careerCompletions = 0;
  int _highStakesSessions = 0;
  bool _isLoading = false;

  StatsProvider({required StatsRepository statsRepository})
      : _statsRepository = statsRepository {
    _loadStats();
  }

  int get totalHandsPlayed => _totalHandsPlayed;
  int get totalRoundsWon => _totalRoundsWon;
  int get totalChipsWon => _totalChipsWon;
  int get totalChipsLost => _totalChipsLost;
  int get instantWins31 => _instantWins31;
  int get instantWinsBlitz => _instantWinsBlitz;
  int get highestPotWon => _highestPotWon;
  int get careerCompletions => _careerCompletions;
  int get highStakesSessions => _highStakesSessions;
  bool get isLoading => _isLoading;

  double get winRate {
    if (_totalHandsPlayed == 0) return 0.0;
    return _totalRoundsWon / _totalHandsPlayed;
  }

  int get netChips => _totalChipsWon - _totalChipsLost;

  Future<void> _loadStats() async {
    _isLoading = true;
    notifyListeners();

    try {
      final stats = await _statsRepository.getStats();
      _totalHandsPlayed = stats.totalHandsPlayed;
      _totalRoundsWon = stats.totalRoundsWon;
      _totalChipsWon = stats.totalChipsWon;
      _totalChipsLost = stats.totalChipsLost;
      _instantWins31 = stats.instantWins31;
      _instantWinsBlitz = stats.instantWinsBlitz;
      _highestPotWon = stats.highestPotWon;
      _careerCompletions = stats.careerCompletions;
      _highStakesSessions = stats.highStakesSessions;
    } catch (e) {
      debugPrint('Error loading stats: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recordHandPlayed() async {
    await _statsRepository.recordHandPlayed();
    _totalHandsPlayed++;
    notifyListeners();
  }

  Future<void> recordRoundWon(int chipsWon) async {
    await _statsRepository.recordRoundWon(chipsWon);
    _totalRoundsWon++;
    _totalChipsWon += chipsWon;
    if (chipsWon > _highestPotWon) {
      _highestPotWon = chipsWon;
    }
    notifyListeners();
  }

  Future<void> recordChipsLost(int chipsLost) async {
    await _statsRepository.recordChipsLost(chipsLost);
    _totalChipsLost += chipsLost;
    notifyListeners();
  }

  Future<void> recordInstantWin31() async {
    await _statsRepository.recordInstantWin31();
    _instantWins31++;
    notifyListeners();
  }

  Future<void> recordInstantWinBlitz() async {
    await _statsRepository.recordInstantWinBlitz();
    _instantWinsBlitz++;
    notifyListeners();
  }

  Future<void> recordCareerCompletion() async {
    await _statsRepository.recordCareerCompletion();
    _careerCompletions++;
    notifyListeners();
  }

  Future<void> recordHighStakesSession() async {
    await _statsRepository.recordHighStakesSession();
    _highStakesSessions++;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadStats();
  }
}

