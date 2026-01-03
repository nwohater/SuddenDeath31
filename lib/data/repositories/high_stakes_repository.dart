import '../datasources/sqlite_datasource.dart';

/// High stakes bankroll model
class HighStakesBankroll {
  final int chips;
  final int activeLoanCount;
  final int loanBalance;
  final int lifetimeProfit;

  const HighStakesBankroll({
    this.chips = 100,
    this.activeLoanCount = 0,
    this.loanBalance = 0,
    this.lifetimeProfit = 0,
  });

  factory HighStakesBankroll.fromMap(Map<String, dynamic> map) {
    return HighStakesBankroll(
      chips: map['chips'] as int? ?? 100,
      activeLoanCount: map['active_loan_count'] as int? ?? 0,
      loanBalance: map['loan_balance'] as int? ?? 0,
      lifetimeProfit: map['lifetime_profit'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chips': chips,
      'active_loan_count': activeLoanCount,
      'loan_balance': loanBalance,
      'lifetime_profit': lifetimeProfit,
    };
  }

  HighStakesBankroll copyWith({
    int? chips,
    int? activeLoanCount,
    int? loanBalance,
    int? lifetimeProfit,
  }) {
    return HighStakesBankroll(
      chips: chips ?? this.chips,
      activeLoanCount: activeLoanCount ?? this.activeLoanCount,
      loanBalance: loanBalance ?? this.loanBalance,
      lifetimeProfit: lifetimeProfit ?? this.lifetimeProfit,
    );
  }

  bool get hasActiveLoan => activeLoanCount > 0;
  bool get canTakeLoan => activeLoanCount < 3;
}

/// Repository for managing high stakes bankroll and loans
class HighStakesRepository {
  final SQLiteDataSource _dataSource;

  HighStakesRepository(this._dataSource);

  /// Get current bankroll
  Future<HighStakesBankroll> getBankroll() async {
    final data = await _dataSource.getHighStakesBankroll();
    if (data == null) {
      return const HighStakesBankroll();
    }
    return HighStakesBankroll.fromMap(data);
  }

  /// Update chips
  Future<void> updateChips(int chips) async {
    final bankroll = await getBankroll();
    await _saveBankroll(bankroll.copyWith(chips: chips));
  }

  /// Add chips (from winnings)
  Future<void> addChips(int amount) async {
    final bankroll = await getBankroll();
    await _saveBankroll(bankroll.copyWith(
      chips: bankroll.chips + amount,
      lifetimeProfit: bankroll.lifetimeProfit + amount,
    ));
  }

  /// Remove chips (from losses)
  Future<void> removeChips(int amount) async {
    final bankroll = await getBankroll();
    await _saveBankroll(bankroll.copyWith(
      chips: bankroll.chips - amount,
      lifetimeProfit: bankroll.lifetimeProfit - amount,
    ));
  }

  /// Take out a loan
  Future<void> takeLoan({
    required int loanAmount,
    required int paybackAmount,
  }) async {
    final bankroll = await getBankroll();
    if (!bankroll.canTakeLoan) {
      throw Exception('Cannot take more than 3 loans');
    }

    await _saveBankroll(bankroll.copyWith(
      chips: bankroll.chips + loanAmount,
      activeLoanCount: bankroll.activeLoanCount + 1,
      loanBalance: bankroll.loanBalance + paybackAmount,
    ));
  }

  /// Repay loan (automatic when winning)
  Future<void> repayLoan(int amount) async {
    final bankroll = await getBankroll();
    if (bankroll.loanBalance == 0) return;

    final repayAmount = amount < bankroll.loanBalance ? amount : bankroll.loanBalance;
    final newBalance = bankroll.loanBalance - repayAmount;
    final newLoanCount = newBalance == 0 ? 0 : bankroll.activeLoanCount;

    await _saveBankroll(bankroll.copyWith(
      chips: bankroll.chips - repayAmount,
      loanBalance: newBalance,
      activeLoanCount: newLoanCount,
    ));
  }

  /// Reset bankroll (for testing or restart)
  Future<void> resetBankroll() async {
    await _saveBankroll(const HighStakesBankroll(chips: 100));
  }

  Future<void> _saveBankroll(HighStakesBankroll bankroll) async {
    await _dataSource.updateHighStakesBankroll(bankroll.toMap());
  }
}

