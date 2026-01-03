import 'npc_profile.dart';

/// Collection of NPC characters with unique personalities
class NPCCharacters {
  // Easy difficulty NPCs
  static const NPCProfile timidTerry = NPCProfile(
    id: 'timid_terry',
    name: 'Timid Terry',
    bio: 'A nervous accountant who counts cards but second-guesses every decision. '
        'Brings a calculator to the table "just in case." '
        'Once folded a winning hand because the pot was "too scary."',
    avatarId: 'terry',
    betAggression: 0.2,
    riskTolerance: 0.1,
    bluffTendency: 0.05,
    suitChasing: 0.3,
    blitzChasing: 0.2,
    swapPreference: 0.3,
    patience: 0.8,
  );

  static const NPCProfile luckyLarry = NPCProfile(
    id: 'lucky_larry',
    name: 'Lucky Larry',
    bio: 'Believes his lucky rabbit\'s foot is the key to victory. '
        'Has never read the rules but insists he "feels the cards." '
        'Wins more often than he should, which annoys everyone.',
    avatarId: 'larry',
    betAggression: 0.6,
    riskTolerance: 0.7,
    bluffTendency: 0.3,
    suitChasing: 0.2,
    blitzChasing: 0.4,
    swapPreference: 0.6,
    patience: 0.2,
  );

  static const NPCProfile grandmaPetunia = NPCProfile(
    id: 'grandma_petunia',
    name: 'Grandma Petunia',
    bio: 'Sweet old lady who knits between turns and offers everyone cookies. '
        'Don\'t let the smile fool you—she\'s been playing cards since before you were born. '
        'Her "lucky shawl" has seen more victories than defeats.',
    avatarId: 'petunia',
    betAggression: 0.3,
    riskTolerance: 0.4,
    bluffTendency: 0.2,
    suitChasing: 0.6,
    blitzChasing: 0.3,
    swapPreference: 0.4,
    patience: 0.9,
  );

  // Medium difficulty NPCs
  static const NPCProfile calculatingCarl = NPCProfile(
    id: 'calculating_carl',
    name: 'Calculating Carl',
    bio: 'Former math professor who treats every hand like a probability equation. '
        'Mutters odds under his breath and adjusts his glasses dramatically. '
        'Once wrote a thesis on optimal 31 strategy (nobody read it).',
    avatarId: 'carl',
    betAggression: 0.5,
    riskTolerance: 0.5,
    bluffTendency: 0.4,
    suitChasing: 0.7,
    blitzChasing: 0.5,
    swapPreference: 0.5,
    patience: 0.7,
  );

  static const NPCProfile bluffingBetty = NPCProfile(
    id: 'bluffing_betty',
    name: 'Bluffing Betty',
    bio: 'Professional poker player slumming it in the 31 circuit. '
        'Wears sunglasses indoors and practices her poker face in the mirror. '
        'Her tells are fake tells designed to confuse you.',
    avatarId: 'betty',
    betAggression: 0.7,
    riskTolerance: 0.6,
    bluffTendency: 0.8,
    suitChasing: 0.4,
    blitzChasing: 0.6,
    swapPreference: 0.6,
    patience: 0.4,
  );

  static const NPCProfile steadySteve = NPCProfile(
    id: 'steady_steve',
    name: 'Steady Steve',
    bio: 'The most boring player at the table, and he knows it. '
        'Plays by the book, never takes unnecessary risks, always tips exactly 15%. '
        'His consistency is both his strength and his curse.',
    avatarId: 'steve',
    betAggression: 0.5,
    riskTolerance: 0.5,
    bluffTendency: 0.3,
    suitChasing: 0.5,
    blitzChasing: 0.5,
    swapPreference: 0.5,
    patience: 0.6,
  );

  // Hard difficulty NPCs
  static const NPCProfile sharkySharpe = NPCProfile(
    id: 'sharky_sharpe',
    name: 'Sharky Sharpe',
    bio: 'Card shark extraordinaire with a mysterious past. '
        'Rumor has it he once won a yacht in a game of 31. '
        'Reads opponents like books and plays like a grandmaster.',
    avatarId: 'sharky',
    betAggression: 0.8,
    riskTolerance: 0.7,
    bluffTendency: 0.7,
    suitChasing: 0.8,
    blitzChasing: 0.7,
    swapPreference: 0.7,
    patience: 0.5,
  );

  static const NPCProfile iceColdIvy = NPCProfile(
    id: 'ice_cold_ivy',
    name: 'Ice Cold Ivy',
    bio: 'Never smiles, never frowns, never shows emotion. '
        'Some say she\'s a robot. Others say she sold her soul for perfect card sense. '
        'Either way, she\'s terrifying to play against.',
    avatarId: 'ivy',
    betAggression: 0.7,
    riskTolerance: 0.6,
    bluffTendency: 0.5,
    suitChasing: 0.9,
    blitzChasing: 0.8,
    swapPreference: 0.8,
    patience: 0.9,
  );

  static const NPCProfile wildCardWillie = NPCProfile(
    id: 'wildcard_willie',
    name: 'Wild Card Willie',
    bio: 'Unpredictable chaos incarnate. Bets high on terrible hands, folds on great ones. '
        'Nobody knows what he\'ll do next—including Willie himself. '
        'Somehow still wins more than he loses.',
    avatarId: 'willie',
    betAggression: 0.9,
    riskTolerance: 0.9,
    bluffTendency: 0.9,
    suitChasing: 0.5,
    blitzChasing: 0.9,
    swapPreference: 0.7,
    patience: 0.1,
  );

  /// Get all NPCs
  static List<NPCProfile> get allNPCs => [
        timidTerry,
        luckyLarry,
        grandmaPetunia,
        calculatingCarl,
        bluffingBetty,
        steadySteve,
        sharkySharpe,
        iceColdIvy,
        wildCardWillie,
      ];

  /// Get NPCs by difficulty
  static List<NPCProfile> getNPCsByDifficulty(String difficulty) {
    return allNPCs.where((npc) => npc.difficultyLevel == difficulty).toList();
  }

  /// Get random NPC
  static NPCProfile getRandomNPC() {
    final random = DateTime.now().millisecondsSinceEpoch % allNPCs.length;
    return allNPCs[random];
  }

  /// Get NPC by ID
  static NPCProfile? getNPCById(String id) {
    try {
      return allNPCs.firstWhere((npc) => npc.id == id);
    } catch (e) {
      return null;
    }
  }
}

