import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  const TransactionRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Transaction>> addTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final result = await localDataSource.addTransaction(model);
      return Right(result.toEntity());
    } on HiveError catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> updateTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final result = await localDataSource.updateTransaction(model);
      return Right(result.toEntity());
    } on NotFoundFailure catch (e) {
      return Left(e);
    } on HiveError catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTransaction(String id) async {
    try {
      await localDataSource.deleteTransaction(id);
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
  Future<Either<Failure, List<Transaction>>> getAllTransactions() async {
    try {
      final models = await localDataSource.getAllTransactions();
      return Right(models.map((m) => m.toEntity()).toList());
    } on HiveError catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      final model = await localDataSource.getTransactionById(id);
      return Right(model.toEntity());
    } on NotFoundFailure catch (e) {
      return Left(e);
    } on HiveError catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}