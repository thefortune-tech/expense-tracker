import 'package:equatable/equatable.dart';

class CategoryBreakdown extends Equatable {
  final String category;
  final double totalSpent;
  final double? budgetLimit;
  final double percentageOfTotalSpending;

  const CategoryBreakdown({
    required this.category,
    required this.totalSpent,
    this.budgetLimit,
    required this.percentageOfTotalSpending,
  });

  bool get hasBudget => budgetLimit != null;

  double get budgetUsagePercent {
    if (budgetLimit == null || budgetLimit == 0) return 0;
    return (totalSpent / budgetLimit!) * 100;
  }

  bool get isOverBudget => hasBudget && totalSpent > budgetLimit!;

  @override
  List<Object?> get props => [category, totalSpent, budgetLimit, percentageOfTotalSpending];
}