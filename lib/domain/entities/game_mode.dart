/// Game modes available in Sudden Death 31
enum GameMode {
  practice,
  career,
  highStakes;

  String get displayName {
    switch (this) {
      case GameMode.practice:
        return 'Practice';
      case GameMode.career:
        return 'Career';
      case GameMode.highStakes:
        return 'High Stakes';
    }
  }
}

