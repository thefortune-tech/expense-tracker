import 'package:equatable/equatable.dart';

import 'category_breakdown.dart';

class DashboardSummary extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final int month;
  final int year;
  final List<CategoryBreakdown> categoryBreakdowns;

  const DashboardSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.month,
    required this.year,
    required this.categoryBreakdowns,
  });

  double get netBalance => totalIncome - totalExpense;

  @override
  List<Object> get props => [totalIncome, totalExpense, month, year, categoryBreakdowns];
}