import 'package:equatable/equatable.dart';

/// Represents a loan in High Stakes mode
class Loan extends Equatable {
  final String id;
  final int amount; // Amount borrowed
  final int payback; // Total amount to repay
  final int remaining; // Remaining balance
  final DateTime takenAt;

  const Loan({
    required this.id,
    required this.amount,
    required this.payback,
    required this.remaining,
    required this.takenAt,
  });

  /// Create a new loan
  factory Loan.create({
    required String id,
    required int amount,
    required int payback,
  }) {
    return Loan(
      id: id,
      amount: amount,
      payback: payback,
      remaining: payback,
      takenAt: DateTime.now(),
    );
  }

  /// Standard loan: borrow 10, repay 12
  factory Loan.standard(String id) {
    return Loan.create(
      id: id,
      amount: 10,
      payback: 12,
    );
  }

  /// Check if loan is fully repaid
  bool get isRepaid => remaining <= 0;

  /// Make a payment towards the loan
  Loan makePayment(int amount) {
    final newRemaining = (remaining - amount).clamp(0, payback);
    return Loan(
      id: id,
      amount: this.amount,
      payback: payback,
      remaining: newRemaining,
      takenAt: takenAt,
    );
  }

  /// Interest rate (as percentage)
  double get interestRate => ((payback - amount) / amount) * 100;

  @override
  List<Object?> get props => [id, amount, payback, remaining, takenAt];

  @override
  String toString() => 'Loan: $remaining/$payback remaining';
}

