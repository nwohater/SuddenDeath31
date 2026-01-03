/// NPC personality profile for AI decision-making
class NPCProfile {
  final String id;
  final String name;
  final String bio;
  final String avatarId; // For future avatar system
  
  // Behavioral traits (0.0 to 1.0)
  final double betAggression; // How likely to bet high amounts
  final double riskTolerance; // Willingness to take risks with marginal hands
  final double bluffTendency; // How often they bet high with weak hands
  final double suitChasing; // Tendency to chase suit combinations
  final double blitzChasing; // Tendency to go for three-of-a-kind
  final double swapPreference; // Preference for swapping vs drawing (0=draw, 1=swap)
  final double patience; // Willingness to wait for better cards
  
  const NPCProfile({
    required this.id,
    required this.name,
    required this.bio,
    this.avatarId = 'default',
    this.betAggression = 0.5,
    this.riskTolerance = 0.5,
    this.bluffTendency = 0.5,
    this.suitChasing = 0.5,
    this.blitzChasing = 0.5,
    this.swapPreference = 0.5,
    this.patience = 0.5,
  });

  /// Create a copy with modified traits
  NPCProfile copyWith({
    String? id,
    String? name,
    String? bio,
    String? avatarId,
    double? betAggression,
    double? riskTolerance,
    double? bluffTendency,
    double? suitChasing,
    double? blitzChasing,
    double? swapPreference,
    double? patience,
  }) {
    return NPCProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarId: avatarId ?? this.avatarId,
      betAggression: betAggression ?? this.betAggression,
      riskTolerance: riskTolerance ?? this.riskTolerance,
      bluffTendency: bluffTendency ?? this.bluffTendency,
      suitChasing: suitChasing ?? this.suitChasing,
      blitzChasing: blitzChasing ?? this.blitzChasing,
      swapPreference: swapPreference ?? this.swapPreference,
      patience: patience ?? this.patience,
    );
  }

  /// Get difficulty level based on traits
  String get difficultyLevel {
    final avgSkill = (betAggression + riskTolerance + patience) / 3;
    if (avgSkill < 0.3) return 'Easy';
    if (avgSkill < 0.6) return 'Medium';
    return 'Hard';
  }

  @override
  String toString() => 'NPCProfile($name, difficulty: $difficultyLevel)';
}

