import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class GetBudgetsForMonth implements UseCase<List<Budget>, GetBudgetsForMonthParams> {
  final BudgetRepository repository;

  const GetBudgetsForMonth(this.repository);

  @override
  Future<Either<Failure, List<Budget>>> call(GetBudgetsForMonthParams params) {
    return repository.getBudgetsForMonth(params.month, params.year);
  }
}

class GetBudgetsForMonthParams extends Equatable {
  final int month;
  final int year;

  const GetBudgetsForMonthParams({required this.month, required this.year});

  @override
  List<Object> get props => [month, year];
}