import 'package:flutter/material.dart';

/// ============================================================================
/// SUDDEN DEATH 31 - THEME & COLOR SYSTEM
/// ============================================================================
/// An ominous, modern aesthetic with deep darks, blood reds, and ember accents.
///

// =============================================================================
// CORE COLOR PALETTE
// =============================================================================

class SuddenDeathColors {
  SuddenDeathColors._();

  // ---------------------------------------------------------------------------
  // BASE COLORS - The foundation
  // ---------------------------------------------------------------------------

  /// Near-black base for backgrounds
  static const Color abyss = Color(0xFF0D0D0F);

  /// Deep charcoal for elevated surfaces
  static const Color charcoal = Color(0xFF1A1A1D);

  /// Slightly lighter for cards/panels
  static const Color slate = Color(0xFF252528);

  /// Dark violet undertone for depth
  static const Color nightshade = Color(0xFF1A0A1A);

  /// Darkest red-black for dramatic areas
  static const Color bloodstone = Color(0xFF1A0510);

  // ---------------------------------------------------------------------------
  // ACCENT COLORS - Danger & Warning
  // ---------------------------------------------------------------------------

  /// Deep blood red - primary danger color
  static const Color bloodRed = Color(0xFF8B0000);

  /// Brighter crimson for active states
  static const Color crimson = Color(0xFFDC143C);

  /// Lighter red for highlights/glows
  static const Color ember = Color(0xFFE53935);

  /// Subtle red for backgrounds
  static const Color bloodMist = Color(0x338B0000);

  // ---------------------------------------------------------------------------
  // HIGHLIGHT COLORS - Modern accents
  // ---------------------------------------------------------------------------

  /// Warm gold for scores, highlights
  static const Color gold = Color(0xFFD4A84B);

  /// Brighter gold for active elements
  static const Color brightGold = Color(0xFFFFD700);

  /// Modern teal accent (use sparingly)
  static const Color teal = Color(0xFF2DD4BF);

  /// Cyan for special effects
  static const Color cyan = Color(0xFF22D3EE);

  // ---------------------------------------------------------------------------
  // NEUTRAL COLORS - Text & UI
  // ---------------------------------------------------------------------------

  /// Bone white for card faces, primary text
  static const Color bone = Color(0xFFE8E4D9);

  /// Slightly darker for secondary text
  static const Color ash = Color(0xFFB8B4A9);

  /// Muted gray for disabled/tertiary
  static const Color dust = Color(0xFF6B6B6B);

  /// Dark gray for borders, dividers
  static const Color shadow = Color(0xFF3A3A3D);

  // ---------------------------------------------------------------------------
  // SEMANTIC COLORS
  // ---------------------------------------------------------------------------

  /// Player life - full
  static const Color lifeFull = crimson;

  /// Player life - empty
  static const Color lifeEmpty = Color(0xFF3A3A3D);

  /// Success state
  static const Color success = Color(0xFF10B981);

  /// Warning state
  static const Color warning = gold;

  /// Error/danger state
  static const Color danger = crimson;

  /// Active player indicator
  static const Color activePlayer = Color(0x4DDC143C);

  // ---------------------------------------------------------------------------
  // CARD SUIT COLORS
  // ---------------------------------------------------------------------------

  static const Color hearts = crimson;
  static const Color diamonds = crimson;
  static const Color spades = Color(0xFF1A1A1D); // Dark charcoal for visibility on light cards
  static const Color clubs = Color(0xFF1A1A1D); // Dark charcoal for visibility on light cards
}

// =============================================================================
// GRADIENTS
// =============================================================================

class SuddenDeathGradients {
  SuddenDeathGradients._();

  /// Main background gradient - radial from center
  static const RadialGradient backgroundRadial = RadialGradient(
    center: Alignment.center,
    radius: 1.2,
    colors: [
      SuddenDeathColors.nightshade,
      SuddenDeathColors.abyss,
      Color(0xFF050505),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Alternative linear background
  static const LinearGradient backgroundLinear = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      SuddenDeathColors.nightshade,
      SuddenDeathColors.abyss,
      SuddenDeathColors.bloodstone,
    ],
  );

  /// Card face gradient
  static const LinearGradient cardFace = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF5F5F0),
      SuddenDeathColors.bone,
      Color(0xFFD4D0C5),
    ],
  );

  /// Card back gradient - much lighter for visibility against dark background
  static const LinearGradient cardBack = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3A3A3D), // Lighter gray
      Color(0xFF2A2A2D), // Medium gray
      SuddenDeathColors.slate,
    ],
  );

  /// Button gradient - default
  static const LinearGradient buttonDefault = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      SuddenDeathColors.charcoal,
      SuddenDeathColors.abyss,
    ],
  );

  /// Button gradient - danger/action (Knock button)
  static const LinearGradient buttonDanger = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      SuddenDeathColors.crimson,
      SuddenDeathColors.bloodRed,
    ],
  );

  /// Gold accent gradient
  static const LinearGradient goldShimmer = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      SuddenDeathColors.brightGold,
      SuddenDeathColors.gold,
      Color(0xFFB8860B),
    ],
  );

  /// Vignette overlay
  static const RadialGradient vignette = RadialGradient(
    center: Alignment.center,
    radius: 0.8,
    colors: [
      Colors.transparent,
      Color(0x99000000),
    ],
    stops: [0.4, 1.0],
  );
}

// =============================================================================
// SHADOWS & GLOWS
// =============================================================================

class SuddenDeathShadows {
  SuddenDeathShadows._();

  /// Standard card shadow
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  /// Selected/active card glow
  static List<BoxShadow> cardGlow = [
    BoxShadow(
      color: SuddenDeathColors.gold.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  /// Discard pile glow
  static List<BoxShadow> discardGlow = [
    BoxShadow(
      color: SuddenDeathColors.crimson.withOpacity(0.3),
      blurRadius: 30,
      spreadRadius: 5,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
  ];

  /// Danger button glow (pulsing knock button)
  static List<BoxShadow> dangerGlow = [
    BoxShadow(
      color: SuddenDeathColors.crimson.withOpacity(0.5),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  /// Glassmorphism panel shadow
  static List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  /// Text glow for title
  static List<Shadow> titleGlow = [
    Shadow(
      color: SuddenDeathColors.bloodRed.withOpacity(0.5),
      blurRadius: 20,
    ),
  ];
}

// =============================================================================
// DECORATIONS
// =============================================================================

class SuddenDeathDecorations {
  SuddenDeathDecorations._();

  /// Glassmorphism panel
  static BoxDecoration glassPanel = BoxDecoration(
    color: Colors.white.withOpacity(0.05),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: Colors.white.withOpacity(0.1),
      width: 1,
    ),
    boxShadow: SuddenDeathShadows.glassShadow,
  );

  /// Active player panel
  static BoxDecoration activePlayerPanel = BoxDecoration(
    color: SuddenDeathColors.activePlayer,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: SuddenDeathColors.crimson.withOpacity(0.4),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: SuddenDeathColors.bloodRed.withOpacity(0.3),
        blurRadius: 20,
      ),
    ],
  );

  /// Card back decoration
  static BoxDecoration cardBack = BoxDecoration(
    gradient: SuddenDeathGradients.cardBack,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: SuddenDeathColors.bloodRed.withOpacity(0.6),
      width: 2,
    ),
    boxShadow: SuddenDeathShadows.cardShadow,
  );

  /// Card face decoration
  static BoxDecoration cardFace = BoxDecoration(
    gradient: SuddenDeathGradients.cardFace,
    borderRadius: BorderRadius.circular(12),
    boxShadow: SuddenDeathShadows.cardShadow,
  );

  /// Life token - filled
  static BoxDecoration lifeTokenFilled = BoxDecoration(
    color: SuddenDeathColors.crimson,
    shape: BoxShape.circle,
    border: Border.all(
      color: SuddenDeathColors.ember,
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: SuddenDeathColors.bloodRed.withOpacity(0.5),
        blurRadius: 8,
      ),
    ],
  );

  /// Life token - empty
  static BoxDecoration lifeTokenEmpty = BoxDecoration(
    color: Colors.transparent,
    shape: BoxShape.circle,
    border: Border.all(
      color: SuddenDeathColors.dust,
      width: 1,
    ),
  );
}

// =============================================================================
// TEXT STYLES
// =============================================================================

class SuddenDeathTextStyles {
  SuddenDeathTextStyles._();

  static const String _fontFamily = 'Inter'; // Or 'Space Grotesk'

  /// Game title
  static TextStyle title = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 4,
    color: SuddenDeathColors.bone,
    shadows: SuddenDeathShadows.titleGlow,
  );

  /// Score display
  static const TextStyle score = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: SuddenDeathColors.gold,
  );

  /// Card value
  static const TextStyle cardValue = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  /// Card suit
  static const TextStyle cardSuit = TextStyle(
    fontSize: 32,
  );

  /// Player name
  static const TextStyle playerName = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: SuddenDeathColors.ash,
  );

  /// Button text
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    color: SuddenDeathColors.bone,
  );

  /// Body text
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    color: SuddenDeathColors.ash,
  );

  /// Caption/small text
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    color: SuddenDeathColors.dust,
  );
}

// =============================================================================
// THEME DATA
// =============================================================================

class SuddenDeathTheme {
  SuddenDeathTheme._();

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: SuddenDeathColors.abyss,

    colorScheme: const ColorScheme.dark(
      surface: SuddenDeathColors.charcoal,
      primary: SuddenDeathColors.crimson,
      secondary: SuddenDeathColors.gold,
      error: SuddenDeathColors.crimson,
      onSurface: SuddenDeathColors.bone,
      onPrimary: SuddenDeathColors.bone,
      onSecondary: SuddenDeathColors.abyss,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: SuddenDeathColors.bone,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SuddenDeathColors.charcoal,
        foregroundColor: SuddenDeathColors.bone,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    cardTheme: const CardThemeData(
      color: SuddenDeathColors.slate,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    iconTheme: const IconThemeData(
      color: SuddenDeathColors.ash,
    ),

    dividerColor: SuddenDeathColors.shadow,
  );
}

// =============================================================================
// ANIMATION DURATIONS
// =============================================================================

class SuddenDeathAnimations {
  SuddenDeathAnimations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration cardFlip = Duration(milliseconds: 400);
  static const Duration cardDeal = Duration(milliseconds: 200);
  static const Duration pulse = Duration(milliseconds: 1500);
}

// =============================================================================
// SIZING CONSTANTS
// =============================================================================

class SuddenDeathSizes {
  SuddenDeathSizes._();

  // Card dimensions (standard poker ratio ~2.5:3.5)
  static const double cardWidth = 70;
  static const double cardHeight = 100;
  static const double cardRadius = 12;

  // Life tokens
  static const double lifeTokenSize = 14;

  // Spacing
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  // Border radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
}