import 'package:equatable/equatable.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class LoadBudgets extends BudgetEvent {
  final int month;
  final int year;

  const LoadBudgets({required this.month, required this.year});

  @override
  List<Object?> get props => [month, year];
}

class SetBudgetEvent extends BudgetEvent {
  final String category;
  final double monthlyLimit;
  final String currencyCode;
  final int month;
  final int year;

  const SetBudgetEvent({
    required this.category,
    required this.monthlyLimit,
    required this.currencyCode,
    required this.month,
    required this.year,
  });

  @override
  List<Object?> get props => [
    category,
    monthlyLimit,
    currencyCode,
    month,
    year,
  ];
}

class DeleteBudgetEvent extends BudgetEvent {
  final String id;

  const DeleteBudgetEvent(this.id);

  @override
  List<Object?> get props => [id];
}
