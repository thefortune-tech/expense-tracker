import 'package:equatable/equatable.dart';

import '../../domain/entities/budget.dart';

enum BudgetStatus { loading, loaded, error }

class BudgetUsage extends Equatable {
  final Budget budget;
  final double spent;

  const BudgetUsage({required this.budget, required this.spent});

  double get usagePercent =>
      budget.monthlyLimit == 0 ? 0 : (spent / budget.monthlyLimit) * 100;

  bool get isOverBudget => spent > budget.monthlyLimit;

  @override
  List<Object> get props => [budget, spent];
}

class BudgetState extends Equatable {
  final BudgetStatus status;
  final List<BudgetUsage> budgetUsages;
  final String? errorMessage;

  const BudgetState({
    this.status = BudgetStatus.loading,
    this.budgetUsages = const [],
    this.errorMessage,
  });

  BudgetState copyWith({
    BudgetStatus? status,
    List<BudgetUsage>? budgetUsages,
    String? errorMessage,
  }) {
    return BudgetState(
      status: status ?? this.status,
      budgetUsages: budgetUsages ?? this.budgetUsages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, budgetUsages, errorMessage];
}
