import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';
import 'budget_validator.dart';

class SetBudget implements UseCase<Budget, SetBudgetParams> {
  final BudgetRepository repository;

  const SetBudget(this.repository);

  @override
  Future<Either<Failure, Budget>> call(SetBudgetParams params) async {
    final validation = BudgetValidator.validate(
      category: params.category,
      monthlyLimit: params.monthlyLimit,
      currencyCode: params.currencyCode,
      month: params.month,
      year: params.year,
    );

    return validation.match(
      (failure) => Left(failure),
      (_) => repository.setBudget(
        Budget(
          id: params.id,
          category: params.category,
          monthlyLimit: params.monthlyLimit,
          currencyCode: params.currencyCode,
          month: params.month,
          year: params.year,
        ),
      ),
    );
  }
}

class SetBudgetParams extends Equatable {
  final String id;
  final String category;
  final double monthlyLimit;
  final String currencyCode;
  final int month;
  final int year;

  const SetBudgetParams({
    required this.id,
    required this.category,
    required this.monthlyLimit,
    required this.currencyCode,
    required this.month,
    required this.year,
  });

  @override
  List<Object> get props => [id, category, monthlyLimit, currencyCode, month, year];
}