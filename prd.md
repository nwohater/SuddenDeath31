# PRD — Sudden Death 31 (Flutter)

## 1. Overview

**Sudden Death 31** is a fast, mobile-first card game based on “31” with a tempo/betting twist: the opening bet determines how many turns the entire round lasts. The product combines:
- **Quick Practice** (risk-free)
- **Career Mode** (venue progression + survival/qualification)
- **High Stakes Mode** (persistent bankroll + loans)
- **Monetization** (ads + remove-ads IAP)
- **Progression** (stats, unlocks, cosmetics, venues, rivals/bosses later)

Target platforms: **iOS + Android**  
Tech: **Flutter**, **Provider**, **Local SQLite** (progress/stats), basic **Clean Architecture**.

---

## 2. Goals and Non-Goals

### Goals
- Deliver a fun, quick core loop (rounds are short, decisions frequent).
- Provide strong “reason to keep playing” via **career progression** and unlocks.
- Maintain fairness: no pay-to-win, no chip purchases.
- Work offline with local progress storage (SQLite).
- Ship with a clean, maintainable architecture.

### Non-Goals (v1)
- Real-money gambling
- Online multiplayer
- Complex narrative cutscenes
- Cloud accounts / cross-device sync (can be a future enhancement)

---

## 3. Core Game Rules (Sudden Death 31)

### 3.1 Components
- Standard 52-card deck
- Chips (virtual, in-app)

### 3.2 Round Setup
- Deal **3 cards** to each player.
- Draw pile: remaining deck face-down.
- Discard pile starts empty.
- Opener rotates clockwise each round.

### 3.3 Opening Bet
- Opener chooses bet **b**.
- **Min bet = 1**
- **Max bet = the smallest chip stack at the table** (prevents bullying low stacks).

All players ante **b** into the pot.  
No raising. No folding. No knocking.

### 3.4 Bet Controls Turn Limit
Total turns for the round:

| Bet | Total Turns |
|-----|-------------|
| 1   | 5           |
| 2   | 4           |
| 3   | 3           |
| 4   | 2           |
| 5+  | 1           |

**Turn = one player action** (clockwise).

### 3.5 Turn Actions (Forced Play)
On your turn you must do one:
- Draw 1 from deck, then discard 1
- Swap 1 from hand with top of discard

No passing.

### 3.6 Instant Win Conditions (Ends Round Immediately)
At any time a player may reveal:
- **31**: three cards of same suit totaling 31
- **Blitz**: three of a kind

That player wins the entire pot; round ends.

### 3.7 End-of-Round Showdown
If no instant win:
- Score = **highest single-suit total** in your hand.
- Highest score wins pot.

### 3.8 Tie-breakers
1) Highest card in scoring suit  
2) Second highest card  
3) Third highest card  
4) Still tied → **split pot evenly**

**Odd chip rule:** if pot split leaves remainder, extra chip goes to the player **closest clockwise to the opener**.

### 3.9 Sudden Death Mode Rule (Endgame)
When **all players** have **≤ 2 chips**:
- Bet is forced to **1**
- Round lasts **5 turns**
- The **next completed round** ends the game.

---

## 4. Game Modes

### 4.1 Practice (Quick Game)
Purpose: low-friction learning.
- Player vs 3 NPCs
- No persistent bankroll risk (chips are “play money”)
- Records stats (optional: yes, track practice separately)
- No loans

### 4.2 Career Mode (Progression / Survival)
Purpose: the main “keep playing” loop.

**High-level concept**
- Career is a run through a sequence of venues.
- Each venue lasts a fixed number of rounds (**5 / 10 / 15 hands**).
- Player does **not** need to finish #1 to progress.
- Player must “qualify” by finishing above a threshold.
- **No loans** in Career mode.
- Career ends if player is broke OR fails to qualify (configurable).

**Venue parameters**
Each venue defines:
- `minBuyIn` (minimum chips required to enter venue)
- `startingChips` (bankroll when entering venue; can be set to a fixed value or “carry in” — see below)
- `handsToPlay` (5, 10, or 15)
- `qualifyLine` (minimum chips at end of venue to advance)
- `targetLine` (optional “win venue” threshold for extra rewards)
- NPC difficulty profile (bet aggression, suit-chasing, blitz-chasing, etc.)

**Carry-in vs Fixed starting chips**
- v1 recommended: **Fixed starting chips per venue** (more controllable difficulty).
- Optional variant (later): “Carry bankroll across venues.”

**Venue completion**
At end of `handsToPlay`:
- If player chips ≥ `qualifyLine` → venue cleared (advance)
- If player chips ≥ `targetLine` or finishes #1 → “won venue” (extra unlocks/cosmetics)
- Else → fail (career ends or replay venue; v1 decision: end run for roguelike feel)

**Recommended venue ladder (example)**
- Venue A (5 hands): minBuyIn 10, startingChips 20, qualify 14, target 26
- Venue B (10 hands): minBuyIn 15, startingChips 25, qualify 18, target 32
- Venue C (15 hands): minBuyIn 20, startingChips 30, qualify 20, target 40
(Tune after playtesting.)

### 4.3 High Stakes Mode (Unlockable)
Unlocked by clearing all Career venues at least once.

- Looks like Quick Game, but chips are **persistent** and you can go broke.
- **Loans allowed** if you fall below minimum buy-in.
- Intended as endless “bankroll management” mode.

**Loans**
- Offered only when player chips < minimum buy-in required to start a match.
- Fixed loan amounts (e.g., +10 chips).
- Fixed payback (e.g., repay 12 chips total).
- Limits: max 1–2 concurrent loans.
- Auto-repayment from future winnings first.

---

## 5. Progression & Retention Systems

### 5.1 Unlocks (Non-Power)
- Card backs
- Table themes / felt
- Chip styles
- Win animations / confetti
- NPC portraits / “rival” profiles (cosmetic flavor)

Unlock triggers:
- Career milestones (clear venue, win venue)
- Achievements (Blitz streak, comeback win, etc.)
- Daily challenges (optional post-v1)

### 5.2 Stats & Achievements
Track (at minimum):
- Games played (by mode)
- Rounds played
- 31 count
- Blitz count
- Biggest pot won
- Biggest comeback (lowest chips → win)
- Win rate by mode
- Average opening bet (player/NPC)

---

## 6. Monetization

### 6.1 Model
- Free-to-play
- **Interstitial ads** between games (never mid-round)
- Optional rewarded ads (small bonuses only, no progression gating)
- One-time IAP: **Remove Ads** (non-consumable)

### 6.2 Ad Guidelines
- Show interstitial at natural pauses:
  - After a full game ends
  - Every N games (e.g., 2–3)
- Never show ads mid-turn / mid-round.

Tech:
- Google AdMob via `google_mobile_ads`

### 6.3 IAP
- Product: `remove_ads` (non-consumable)
- If purchased:
  - Disable all ads permanently.

---

## 7. UX / Screens (v1)

### Main
- Home
  - Practice
  - Career
  - High Stakes (locked/unlocked)
  - Settings
  - Stats

### Gameplay
- Table Screen (core)
  - Player hand (3 cards)
  - Discard pile (top card visible)
  - Deck (tap to draw)
  - Bet display + turn counter
  - Pot display
  - Chip stacks for all players
  - Action buttons (Draw+Discard / Swap)
  - Instant Win button (“Reveal 31 / Blitz”) with validation

### Career
- Venue Select / Map
  - Venue details: hands, starting chips, qualify, target
- Venue Results Summary
- Career Summary (on bust/fail)

### High Stakes
- Bankroll screen
- Loan offer modal when below buy-in

### Monetization
- Remove Ads purchase screen

---

## 8. Data & Storage (SQLite)

### 8.1 Requirements
- Offline-first
- Single local SQLite DB
- Track:
  - User settings
  - Purchases flags (local cache)
  - Career progress/unlocks
  - Stats (aggregate + optional per-game log)

### 8.2 Suggested Tables (minimal viable)

#### `app_settings`
- `key` TEXT PRIMARY KEY
- `value` TEXT

Examples:
- `soundEnabled`, `hapticsEnabled`, `themeId`, `isPremiumCached`

#### `player_profile`
- `id` INTEGER PRIMARY KEY (always 1)
- `careerUnlocked` INTEGER (0/1)
- `highStakesUnlocked` INTEGER (0/1)
- `selectedCosmeticSetId` TEXT
- `createdAt` TEXT

#### `career_state`
- `id` INTEGER PRIMARY KEY (always 1)
- `isActive` INTEGER
- `currentVenueId` TEXT
- `chips` INTEGER
- `handsRemaining` INTEGER
- `completedVenueIds` TEXT (json array)
- `completedOnce` INTEGER (0/1)

#### `high_stakes_bankroll`
- `id` INTEGER PRIMARY KEY (always 1)
- `chips` INTEGER
- `activeLoanCount` INTEGER
- `loanBalance` INTEGER (total repay remaining)

#### `stats_aggregate`
- `id` INTEGER PRIMARY KEY (always 1)
- `practiceGames` INTEGER
- `careerGames` INTEGER
- `highStakesGames` INTEGER
- `totalHands` INTEGER
- `total31` INTEGER
- `totalBlitz` INTEGER
- `biggestPot` INTEGER
- `biggestComeback` INTEGER
- `winsPractice` INTEGER
- `winsCareer` INTEGER
- `winsHighStakes` INTEGER

#### Optional (nice-to-have): `game_history`
- `id` INTEGER PRIMARY KEY AUTOINCREMENT
- `mode` TEXT
- `timestamp` TEXT
- `finalChips` INTEGER
- `result` TEXT (WIN/LOSS/QUALIFY/FAIL)
- `notes` TEXT (json)

---

## 9. Architecture & State Management

### 9.1 Clean Architecture (basic)
**Presentation**
- Screens, widgets
- Provider view-models (ChangeNotifier)
- UI state + navigation decisions

**Domain**
- Entities: Card, Hand, Player, RoundState, Venue, Loan, Stats
- Use cases:
  - StartPracticeGame
  - StartCareer
  - StartVenue
  - PlayTurn
  - EvaluateInstantWin
  - ResolveRound
  - ApplyTieBreak
  - CompleteVenue
  - UnlockHighStakes
  - OfferLoan
  - PurchaseRemoveAds
  - RecordStats

**Data**
- Repositories:
  - GameRepository (local state + engine persistence hooks)
  - ProfileRepository (SQLite)
  - StatsRepository (SQLite)
  - MonetizationRepository (IAP state)
- Data sources:
  - SQLiteDataSource (sqflite)
  - AdMobService
  - IAPService

### 9.2 Provider Setup
- `GameController` (ChangeNotifier): round state, actions, timers, animation triggers
- `CareerController`: venue state, progression
- `HighStakesController`: bankroll + loans
- `StatsController`: read/update aggregates
- `SettingsController`: theme, sound, premium flag

Use `MultiProvider` at app root.

---

## 10. NPC / AI (v1)

### 10.1 Goals
NPCs should feel different without cheating:
- Bet aggression
- Suit-chasing tendency
- Blitz-chasing tendency
- Risk tolerance near end of round

### 10.2 AI Approach (simple heuristics)
- Evaluate hand strength:
  - Best suit total
  - Potential improvement (remaining deck unknown; use heuristics)
- Decide action:
  - If close to 31 in a suit: prioritize draw/discard for that suit
  - If holding pair: consider blitz chase
  - When turn limit is low: favor “lock-in” improvements fast

NPC profiles per venue:
- Easy: conservative bets, weaker chase logic
- Medium: balanced
- Hard: higher bets when strong, better discard logic

---

## 11. Balancing & Tuning

### 11.1 Venue lengths
Venue types: **5 / 10 / 15 hands**
- 5-hand: onboarding / early success
- 10-hand: core experience
- 15-hand: late-game challenge

### 11.2 Guardrails
- Bet cap tied to lowest stack prevents runaway bullying.
- Career “qualify line” prevents needing to place #1 to progress.
- High Stakes loans provide comeback loops only after unlock.

---

## 12. Non-Functional Requirements

- Offline support (full gameplay offline)
- Smooth 60fps animations on modern devices
- Deterministic rules engine (easy to test)
- Unit tests for:
  - scoring
  - tie-breakers
  - instant win validation
  - turn-limit logic
  - loan repayment logic

---

## 13. Milestones

### MVP (v1)
- Core rules engine + UI table
- Practice mode
- Career mode with 3 venues (5/10/15)
- SQLite stats + career progress
- Basic NPC AI
- Interstitial ads
- Remove-ads IAP

### v1.1
- High Stakes unlock + bankroll persistence + loans
- Cosmetics unlocks (at least a few)
- Enhanced stats screen

### v1.2+
- Boss/rivals
- Daily challenges
- Leaderboards (optional, online)
- Cloud sync

---

## 14. Open Decisions (Lock for v1)
- Career failure handling:
  - End run (roguelike) vs replay venue (more casual)
- Career starting chips:
  - Fixed per venue (recommended) vs carry bankroll
- Rewarded ads:
  - Include at launch or post-v1

---

## 15. Acceptance Criteria (v1)
- Player can complete a full Practice game.
- Career mode:
  - Enter venue, play fixed hands, qualify/advance, fail conditions work.
- Stats saved and visible after app restart.
- Ads appear only between games for non-premium users.
- “Remove Ads” purchase disables ads permanently.
- App runs on iOS + Android with stable performance.
