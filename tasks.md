# Sudden Death 31 - Development Tasks

## Phase 1: Project Setup & Foundation

### 1.1 Flutter Project Initialization
- [ ] Create new Flutter project with iOS and Android support
- [ ] Configure project structure following Clean Architecture
- [ ] Set up folder structure: `lib/presentation`, `lib/domain`, `lib/data`
- [ ] Configure `pubspec.yaml` with initial dependencies:
  - `provider` (state management)
  - `sqflite` (local database)
  - `path_provider` (file system access)
  - `google_mobile_ads` (monetization)
  - `in_app_purchase` (IAP)
- [ ] Set up development environment for iOS and Android testing
- [ ] Initialize Git repository and create `.gitignore`

### 1.2 Database Setup
- [ ] Create SQLite database schema
- [ ] Implement `app_settings` table
- [ ] Implement `player_profile` table
- [ ] Implement `career_state` table
- [ ] Implement `high_stakes_bankroll` table
- [ ] Implement `stats_aggregate` table
- [ ] (Optional) Implement `game_history` table
- [ ] Create database helper/service class
- [ ] Write database migration logic
- [ ] Test database CRUD operations

---

## Phase 2: Domain Layer (Core Game Logic)

### 2.1 Core Entities
- [ ] Create `Card` entity (suit, rank, value)
- [ ] Create `Hand` entity (3-card collection with scoring logic)
- [ ] Create `Player` entity (chips, hand, position, isNPC)
- [ ] Create `RoundState` entity (players, pot, turn count, bet amount)
- [ ] Create `Venue` entity (config: minBuyIn, startingChips, handsToPlay, qualifyLine, targetLine)
- [ ] Create `Loan` entity (amount, payback, status)
- [ ] Create `Stats` entity (aggregate statistics)
- [ ] Create `GameMode` enum (Practice, Career, HighStakes)

### 2.2 Game Rules Engine
- [ ] Implement deck shuffling and dealing logic
- [ ] Implement hand scoring (highest single-suit total)
- [ ] Implement instant win detection (31 and Blitz)
- [ ] Implement tie-breaker logic (highest card, second, third, split pot)
- [ ] Implement odd chip distribution rule
- [ ] Implement bet-to-turn-limit mapping (1→5, 2→4, 3→3, 4→2, 5+→1)
- [ ] Implement max bet calculation (smallest stack at table)
- [ ] Implement Sudden Death mode trigger (all players ≤2 chips)
- [ ] Write unit tests for all scoring logic
- [ ] Write unit tests for tie-breaker logic
- [ ] Write unit tests for instant win validation
- [ ] Write unit tests for turn-limit logic

### 2.3 Use Cases
- [ ] `StartPracticeGame` use case
- [ ] `StartCareer` use case
- [ ] `StartVenue` use case
- [ ] `PlayTurn` use case (draw+discard or swap)
- [ ] `EvaluateInstantWin` use case
- [ ] `ResolveRound` use case (showdown, pot distribution)
- [ ] `ApplyTieBreak` use case
- [ ] `CompleteVenue` use case (check qualify/target lines)
- [ ] `UnlockHighStakes` use case
- [ ] `OfferLoan` use case
- [ ] `RepayLoan` use case (auto-repayment logic)
- [ ] `PurchaseRemoveAds` use case
- [ ] `RecordStats` use case
- [ ] Write unit tests for each use case

---

## Phase 3: Data Layer (Repositories & Services)

### 3.1 Repositories
- [ ] Create `GameRepository` (in-memory game state management)
- [ ] Create `ProfileRepository` (SQLite: player profile, unlocks)
- [ ] Create `CareerRepository` (SQLite: career state, venue progress)
- [ ] Create `HighStakesRepository` (SQLite: bankroll, loans)
- [ ] Create `StatsRepository` (SQLite: aggregate stats, game history)
- [ ] Create `SettingsRepository` (SQLite: app settings)
- [ ] Create `MonetizationRepository` (IAP state, ad removal flag)

### 3.2 External Services
- [ ] Implement `SQLiteDataSource` (sqflite wrapper)
- [ ] Implement `AdMobService` (interstitial ads, rewarded ads)
- [ ] Implement `IAPService` (remove ads purchase)
- [ ] Test AdMob integration (test ads)
- [ ] Test IAP integration (sandbox environment)

---

## Phase 4: NPC AI System

### 4.1 AI Logic
- [ ] Create `NPCProfile` entity (bet aggression, suit-chasing, blitz-chasing, risk tolerance)
- [ ] Implement hand strength evaluation heuristic
- [ ] Implement suit-chasing logic (prioritize cards in best suit)
- [ ] Implement blitz-chasing logic (prioritize matching ranks)
- [ ] Implement bet decision logic (based on hand strength and profile)
- [ ] Implement turn action decision (draw/discard vs swap)
- [ ] Create Easy NPC profile (conservative)
- [ ] Create Medium NPC profile (balanced)
- [ ] Create Hard NPC profile (aggressive, smart)
- [ ] Write unit tests for AI decision-making

### 4.2 NPC Venue Assignment
- [ ] Define NPC profiles for each venue
- [ ] Implement NPC selection logic per venue

---

## Phase 5: Presentation Layer (State Management)

### 5.1 Controllers (Provider ChangeNotifiers)
- [ ] Create `GameController` (round state, actions, turn management)
- [ ] Create `CareerController` (venue state, progression)
- [ ] Create `HighStakesController` (bankroll, loans)
- [ ] Create `StatsController` (read/update stats)
- [ ] Create `SettingsController` (theme, sound, haptics, premium flag)
- [ ] Create `MonetizationController` (ad state, IAP state)
- [ ] Set up `MultiProvider` at app root
- [ ] Test state updates and UI reactivity

---

## Phase 6: UI/UX Implementation

### 6.1 Core Screens
- [ ] Create `HomeScreen` (Practice, Career, High Stakes, Settings, Stats)
- [ ] Create `TableScreen` (main gameplay UI)
  - [ ] Player hand display (3 cards)
  - [ ] Discard pile (top card visible)
  - [ ] Deck (draw button)
  - [ ] Bet display + turn counter
  - [ ] Pot display
  - [ ] Chip stacks for all players
  - [ ] Action buttons (Draw+Discard / Swap)
  - [ ] Instant Win button (Reveal 31/Blitz with validation)
  - [ ] NPC player positions and hands (face-down)
- [ ] Create `SettingsScreen` (sound, haptics, theme, remove ads)
- [ ] Create `StatsScreen` (aggregate stats display)

### 6.2 Career Mode Screens
- [ ] Create `VenueSelectScreen` (venue map/list)
- [ ] Create `VenueDetailsScreen` (hands, starting chips, qualify, target)
- [ ] Create `VenueResultsScreen` (qualify/fail, unlocks earned)
- [ ] Create `CareerSummaryScreen` (on bust/fail)

### 6.3 High Stakes Screens
- [ ] Create `HighStakesBankrollScreen` (current bankroll, loan status)
- [ ] Create `LoanOfferModal` (when below buy-in)

### 6.4 Monetization Screens
- [ ] Create `RemoveAdsScreen` (purchase flow)
- [ ] Implement interstitial ad display logic (between games)

### 6.5 UI Components & Widgets
- [ ] Create `CardWidget` (display card with suit/rank)
- [ ] Create `ChipStackWidget` (display chip count)
- [ ] Create `PotWidget` (display pot amount)
- [ ] Create `PlayerWidget` (NPC/player display with chips and hand)
- [ ] Create `BetSelectorWidget` (opening bet selection)
- [ ] Create `TurnCounterWidget` (remaining turns display)
- [ ] Create `ActionButtonWidget` (draw, discard, swap, reveal)

### 6.6 Animations & Polish
- [ ] Implement card dealing animation
- [ ] Implement card flip animation
- [ ] Implement chip movement to pot animation
- [ ] Implement pot distribution animation
- [ ] Implement instant win celebration animation
- [ ] Implement win confetti/effects
- [ ] Add sound effects (card flip, chip clink, win sound)
- [ ] Add haptic feedback for key actions
- [ ] Implement smooth transitions between screens

---

## Phase 7: Game Modes Implementation

### 7.1 Practice Mode
- [ ] Implement Practice game initialization (player + 3 NPCs)
- [ ] Implement play-money chip system (no persistence)
- [ ] Implement game loop (rounds until completion)
- [ ] Implement game end conditions
- [ ] Track practice stats (optional separate tracking)
- [ ] Test full Practice game flow

### 7.2 Career Mode
- [ ] Define venue configuration data (3 venues: 5/10/15 hands)
  - [ ] Venue A: 5 hands, minBuyIn 10, startingChips 20, qualify 14, target 26
  - [ ] Venue B: 10 hands, minBuyIn 15, startingChips 25, qualify 18, target 32
  - [ ] Venue C: 15 hands, minBuyIn 20, startingChips 30, qualify 20, target 40
- [ ] Implement Career initialization
- [ ] Implement venue entry validation (minBuyIn check)
- [ ] Implement fixed starting chips per venue
- [ ] Implement hands countdown (5/10/15)
- [ ] Implement qualify/target line evaluation
- [ ] Implement venue completion logic (advance/fail)
- [ ] Implement career failure handling (end run)
- [ ] Implement career completion (unlock High Stakes)
- [ ] Persist career state to SQLite
- [ ] Test full Career mode flow

### 7.3 High Stakes Mode
- [ ] Implement High Stakes unlock check
- [ ] Implement persistent bankroll system
- [ ] Implement loan offer trigger (chips < minBuyIn)
- [ ] Implement loan acceptance/decline
- [ ] Implement auto-repayment from winnings
- [ ] Implement loan limit enforcement (max 1-2 concurrent)
- [ ] Persist High Stakes state to SQLite
- [ ] Test full High Stakes flow with loans

---

## Phase 8: Progression & Unlocks

### 8.1 Cosmetics System
- [ ] Create cosmetic asset structure (card backs, table themes, chip styles)
- [ ] Implement card back variants (at least 3)
- [ ] Implement table theme variants (at least 3)
- [ ] Implement chip style variants (at least 3)
- [ ] Create unlock conditions (career milestones, achievements)
- [ ] Implement unlock tracking in SQLite
- [ ] Implement cosmetic selection UI
- [ ] Apply selected cosmetics to game UI

### 8.2 Achievements
- [ ] Define achievement list:
  - [ ] First 31
  - [ ] First Blitz
  - [ ] Blitz streak (3 in a row)
  - [ ] Comeback win (lowest chips → win)
  - [ ] Clear all Career venues
  - [ ] Win 10/50/100 games
  - [ ] Biggest pot (thresholds)
- [ ] Implement achievement tracking logic
- [ ] Implement achievement unlock notifications
- [ ] Create achievements display screen
- [ ] Persist achievements to SQLite

---

## Phase 9: Monetization Integration

### 9.1 AdMob Setup
- [ ] Create AdMob account and app registration
- [ ] Configure iOS AdMob app ID
- [ ] Configure Android AdMob app ID
- [ ] Implement interstitial ad loading
- [ ] Implement interstitial ad display logic (after N games)
- [ ] Implement ad frequency control (every 2-3 games)
- [ ] Test ads in development (test ad units)
- [ ] Implement ad error handling

### 9.2 In-App Purchase (Remove Ads)
- [ ] Configure iOS App Store Connect (IAP product)
- [ ] Configure Google Play Console (IAP product)
- [ ] Implement IAP initialization
- [ ] Implement "Remove Ads" purchase flow
- [ ] Implement purchase verification
- [ ] Implement purchase restoration
- [ ] Persist premium flag to SQLite
- [ ] Disable ads when premium flag is true
- [ ] Test IAP in sandbox/test environments

### 9.3 (Optional) Rewarded Ads
- [ ] Implement rewarded ad loading
- [ ] Implement rewarded ad display
- [ ] Define small bonus rewards (no progression gating)
- [ ] Test rewarded ad flow

---

## Phase 10: Testing & Quality Assurance

### 10.1 Unit Tests
- [ ] Test all domain entities
- [ ] Test all use cases
- [ ] Test scoring logic (100% coverage)
- [ ] Test tie-breaker logic (100% coverage)
- [ ] Test instant win validation (100% coverage)
- [ ] Test turn-limit logic (100% coverage)
- [ ] Test loan repayment logic (100% coverage)
- [ ] Test NPC AI decision-making
- [ ] Achieve >80% code coverage for domain layer

### 10.2 Integration Tests
- [ ] Test full game round flow (Practice)
- [ ] Test full game round flow (Career)
- [ ] Test full game round flow (High Stakes)
- [ ] Test database persistence and retrieval
- [ ] Test state management updates
- [ ] Test navigation flows

### 10.3 Widget Tests
- [ ] Test TableScreen UI components
- [ ] Test HomeScreen navigation
- [ ] Test Settings screen
- [ ] Test Stats screen
- [ ] Test Career screens
- [ ] Test High Stakes screens

### 10.4 Manual Testing
- [ ] Test on iOS device (iPhone)
- [ ] Test on Android device
- [ ] Test on various screen sizes (phone, tablet)
- [ ] Test offline functionality
- [ ] Test app restart (state persistence)
- [ ] Test edge cases (all players tie, sudden death mode, etc.)
- [ ] Performance testing (60fps target)
- [ ] Memory leak testing

---

## Phase 11: Polish & Optimization

### 11.1 Performance
- [ ] Optimize animations for 60fps
- [ ] Optimize database queries
- [ ] Reduce app startup time
- [ ] Optimize asset loading
- [ ] Profile and fix memory leaks

### 11.2 UX Improvements
- [ ] Add loading indicators
- [ ] Add error messages and user feedback
- [ ] Implement tutorial/onboarding (optional)
- [ ] Add help/rules screen
- [ ] Improve accessibility (font sizes, contrast)
- [ ] Add haptic feedback polish

### 11.3 Balancing & Tuning
- [ ] Playtest venue difficulty (adjust qualify/target lines)
- [ ] Tune NPC AI difficulty per venue
- [ ] Balance loan amounts and payback rates
- [ ] Adjust ad frequency based on user feedback
- [ ] Fine-tune turn limits and bet mapping (if needed)

---

## Phase 12: Release Preparation

### 12.1 App Store Assets
- [ ] Create app icon (iOS and Android)
- [ ] Create app screenshots (iOS)
- [ ] Create app screenshots (Android)
- [ ] Write app description
- [ ] Create promotional graphics
- [ ] Prepare privacy policy
- [ ] Prepare terms of service

### 12.2 iOS Release
- [ ] Configure App Store Connect listing
- [ ] Set up app metadata (name, description, keywords)
- [ ] Upload screenshots and preview videos
- [ ] Configure pricing (free)
- [ ] Configure IAP product (Remove Ads)
- [ ] Submit for App Store review
- [ ] Address review feedback (if any)
- [ ] Release to App Store

### 12.3 Android Release
- [ ] Configure Google Play Console listing
- [ ] Set up app metadata (name, description, keywords)
- [ ] Upload screenshots and feature graphic
- [ ] Configure pricing (free)
- [ ] Configure IAP product (Remove Ads)
- [ ] Create release APK/AAB
- [ ] Submit for Google Play review
- [ ] Address review feedback (if any)
- [ ] Release to Google Play

### 12.4 Post-Launch
- [ ] Monitor crash reports (Firebase Crashlytics or similar)
- [ ] Monitor user reviews and ratings
- [ ] Track analytics (game sessions, retention, monetization)
- [ ] Plan v1.1 features based on feedback

---

## Phase 13: Future Enhancements (v1.1+)

### 13.1 v1.1 Features
- [ ] Implement additional cosmetics (card backs, themes, chip styles)
- [ ] Enhance stats screen with graphs and trends
- [ ] Add more achievements
- [ ] Implement boss/rival NPCs with unique personalities
- [ ] Add daily challenges system

### 13.2 v1.2+ Features
- [ ] Implement cloud save / cross-device sync
- [ ] Add online leaderboards
- [ ] Implement social features (share wins)
- [ ] Add more venues (expand career mode)
- [ ] Implement tournament mode
- [ ] Add narrative elements (story mode)

---

## Notes & Decisions

### Locked Decisions for v1:
- **Career failure handling**: End run (roguelike feel) — no venue replay
- **Career starting chips**: Fixed per venue (not carry bankroll)
- **Rewarded ads**: Post-v1 (focus on interstitial + IAP first)

### Key Milestones:
- **MVP Complete**: Core rules engine + Practice mode + Career mode (3 venues) + Ads + IAP
- **v1.0 Launch**: All MVP features + High Stakes mode + basic cosmetics + stats
- **v1.1**: Enhanced progression, cosmetics, boss NPCs, daily challenges
- **v1.2+**: Cloud sync, leaderboards, social features

---

## Acceptance Criteria (v1.0)

- ✅ Player can complete a full Practice game
- ✅ Career mode: Enter venue, play fixed hands, qualify/advance, fail conditions work
- ✅ Stats saved and visible after app restart
- ✅ Ads appear only between games for non-premium users
- ✅ "Remove Ads" purchase disables ads permanently
- ✅ App runs on iOS + Android with stable performance (60fps)
- ✅ All core game rules implemented correctly (scoring, tie-breakers, instant wins, turn limits)
- ✅ High Stakes mode unlocks after Career completion
- ✅ Loans work correctly in High Stakes mode
- ✅ Offline functionality works (no internet required for gameplay)

