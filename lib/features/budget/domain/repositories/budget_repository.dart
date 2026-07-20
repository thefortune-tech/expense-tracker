import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/budget.dart';

abstract class BudgetRepository {
  Future<Either<Failure, Budget>> setBudget(Budget budget);

  Future<Either<Failure, Unit>> deleteBudget(String id);

  Future<Either<Failure, List<Budget>>> getBudgetsForMonth(int month, int year);

  Future<Either<Failure, Budget?>> getBudgetForCategory({
    required String category,
    required int month,
    required int year,
  });
}