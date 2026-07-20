import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_local_datasource.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDataSource localDataSource;

  const BudgetRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Budget>> setBudget(Budget budget) async {
    try {
      final model = BudgetModel.fromEntity(budget);
      final result = await localDataSource.setBudget(model);
      return Right(result.toEntity());
    } on HiveError catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBudget(String id) async {
    try {
      await localDataSource.deleteBudget(id);
      return const Right(unit);
    } on NotFoundFailure catch (e) {
      return Left(e);
    } on HiveError catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Budget>>> getBudgetsForMonth(int month, int year) async {
    try {
      final models = await localDataSource.getBudgetsForMonth(month, year);
      return Right(models.map((m) => m.toEntity()).toList());
    } on HiveError catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget?>> getBudgetForCategory({
    required String category,
    required int month,
    required int year,
  }) async {
    try {
      final model = await localDataSource.getBudgetForCategory(
        category: category,
        month: month,
        year: year,
      );
      return Right(model?.toEntity());
    } on HiveError catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}