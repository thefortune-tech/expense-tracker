import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class GetBudgetForCategory implements UseCase<Budget?, GetBudgetForCategoryParams> {
  final BudgetRepository repository;

  const GetBudgetForCategory(this.repository);

  @override
  Future<Either<Failure, Budget?>> call(GetBudgetForCategoryParams params) {
    return repository.getBudgetForCategory(
      category: params.category,
      month: params.month,
      year: params.year,
    );
  }
}

class GetBudgetForCategoryParams extends Equatable {
  final String category;
  final int month;
  final int year;

  const GetBudgetForCategoryParams({
    required this.category,
    required this.month,
    required this.year,
  });

  @override
  List<Object> get props => [category, month, year];
}