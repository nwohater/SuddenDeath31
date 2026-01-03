import 'dart:convert';
import '../datasources/sqlite_datasource.dart';

/// Career state model
class CareerState {
  final bool isActive;
  final String? currentVenueId;
  final int chips;
  final int handsRemaining;
  final List<String> completedVenueIds;
  final bool completedOnce;

  const CareerState({
    this.isActive = false,
    this.currentVenueId,
    this.chips = 0,
    this.handsRemaining = 0,
    this.completedVenueIds = const [],
    this.completedOnce = false,
  });

  factory CareerState.fromMap(Map<String, dynamic> map) {
    final completedVenuesJson = map['completed_venue_ids'] as String? ?? '[]';
    final completedVenues = (jsonDecode(completedVenuesJson) as List)
        .map((e) => e.toString())
        .toList();

    return CareerState(
      isActive: (map['is_active'] as int? ?? 0) == 1,
      currentVenueId: map['current_venue_id'] as String?,
      chips: map['chips'] as int? ?? 0,
      handsRemaining: map['hands_remaining'] as int? ?? 0,
      completedVenueIds: completedVenues,
      completedOnce: (map['completed_once'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'is_active': isActive ? 1 : 0,
      'current_venue_id': currentVenueId,
      'chips': chips,
      'hands_remaining': handsRemaining,
      'completed_venue_ids': jsonEncode(completedVenueIds),
      'completed_once': completedOnce ? 1 : 0,
    };
  }

  CareerState copyWith({
    bool? isActive,
    String? currentVenueId,
    int? chips,
    int? handsRemaining,
    List<String>? completedVenueIds,
    bool? completedOnce,
  }) {
    return CareerState(
      isActive: isActive ?? this.isActive,
      currentVenueId: currentVenueId ?? this.currentVenueId,
      chips: chips ?? this.chips,
      handsRemaining: handsRemaining ?? this.handsRemaining,
      completedVenueIds: completedVenueIds ?? this.completedVenueIds,
      completedOnce: completedOnce ?? this.completedOnce,
    );
  }
}

/// Repository for managing career mode state
class CareerRepository {
  final SQLiteDataSource _dataSource;

  CareerRepository(this._dataSource);

  /// Get current career state
  Future<CareerState> getCareerState() async {
    final data = await _dataSource.getCareerState();
    if (data == null) {
      return const CareerState();
    }
    return CareerState.fromMap(data);
  }

  /// Start a new career
  Future<void> startCareer({
    required String venueId,
    required int startingChips,
    required int handsToPlay,
  }) async {
    final state = CareerState(
      isActive: true,
      currentVenueId: venueId,
      chips: startingChips,
      handsRemaining: handsToPlay,
      completedVenueIds: const [],
      completedOnce: false,
    );
    await _saveState(state);
  }

  /// Update chips
  Future<void> updateChips(int chips) async {
    final state = await getCareerState();
    await _saveState(state.copyWith(chips: chips));
  }

  /// Decrement hands remaining
  Future<void> decrementHands() async {
    final state = await getCareerState();
    await _saveState(state.copyWith(
      handsRemaining: state.handsRemaining - 1,
    ));
  }

  /// Complete current venue
  Future<void> completeVenue() async {
    final state = await getCareerState();
    if (state.currentVenueId == null) return;

    final updatedCompleted = [...state.completedVenueIds, state.currentVenueId!];
    await _saveState(state.copyWith(
      completedVenueIds: updatedCompleted,
      currentVenueId: null,
      isActive: false,
    ));
  }

  /// Move to next venue
  Future<void> moveToNextVenue({
    required String venueId,
    required int handsToPlay,
  }) async {
    final state = await getCareerState();
    await _saveState(state.copyWith(
      currentVenueId: venueId,
      handsRemaining: handsToPlay,
      isActive: true,
    ));
  }

  /// Mark career as completed once
  Future<void> markCareerCompleted() async {
    final state = await getCareerState();
    await _saveState(state.copyWith(
      completedOnce: true,
      isActive: false,
    ));
  }

  /// End career (fail or quit)
  Future<void> endCareer() async {
    final state = await getCareerState();
    await _saveState(state.copyWith(
      isActive: false,
      currentVenueId: null,
    ));
  }

  Future<void> _saveState(CareerState state) async {
    await _dataSource.updateCareerState(state.toMap());
  }
}

