import 'package:equatable/equatable.dart';

/// Represents aggregate game statistics
class Stats extends Equatable {
  final int practiceGames;
  final int careerGames;
  final int highStakesGames;
  final int totalHands;
  final int total31;
  final int totalBlitz;
  final int biggestPot;
  final int biggestComeback;
  final int winsPractice;
  final int winsCareer;
  final int winsHighStakes;

  const Stats({
    this.practiceGames = 0,
    this.careerGames = 0,
    this.highStakesGames = 0,
    this.totalHands = 0,
    this.total31 = 0,
    this.totalBlitz = 0,
    this.biggestPot = 0,
    this.biggestComeback = 0,
    this.winsPractice = 0,
    this.winsCareer = 0,
    this.winsHighStakes = 0,
  });

  /// Create from database map
  factory Stats.fromMap(Map<String, dynamic> map) {
    return Stats(
      practiceGames: map['practice_games'] as int? ?? 0,
      careerGames: map['career_games'] as int? ?? 0,
      highStakesGames: map['high_stakes_games'] as int? ?? 0,
      totalHands: map['total_hands'] as int? ?? 0,
      total31: map['total_31'] as int? ?? 0,
      totalBlitz: map['total_blitz'] as int? ?? 0,
      biggestPot: map['biggest_pot'] as int? ?? 0,
      biggestComeback: map['biggest_comeback'] as int? ?? 0,
      winsPractice: map['wins_practice'] as int? ?? 0,
      winsCareer: map['wins_career'] as int? ?? 0,
      winsHighStakes: map['wins_high_stakes'] as int? ?? 0,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'practice_games': practiceGames,
      'career_games': careerGames,
      'high_stakes_games': highStakesGames,
      'total_hands': totalHands,
      'total_31': total31,
      'total_blitz': totalBlitz,
      'biggest_pot': biggestPot,
      'biggest_comeback': biggestComeback,
      'wins_practice': winsPractice,
      'wins_career': winsCareer,
      'wins_high_stakes': winsHighStakes,
    };
  }

  /// Total games played
  int get totalGames => practiceGames + careerGames + highStakesGames;

  /// Total wins
  int get totalWins => winsPractice + winsCareer + winsHighStakes;

  /// Win rate (0.0 to 1.0)
  double get winRate {
    if (totalGames == 0) return 0.0;
    return totalWins / totalGames;
  }

  /// Total instant wins
  int get totalInstantWins => total31 + totalBlitz;

  @override
  List<Object?> get props => [
        practiceGames,
        careerGames,
        highStakesGames,
        totalHands,
        total31,
        totalBlitz,
        biggestPot,
        biggestComeback,
        winsPractice,
        winsCareer,
        winsHighStakes,
      ];
}

