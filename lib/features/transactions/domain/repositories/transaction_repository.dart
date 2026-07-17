import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Transaction>> addTransaction(Transaction transaction);

  Future<Either<Failure, Transaction>> updateTransaction(Transaction transaction);

  Future<Either<Failure, Unit>> deleteTransaction(String id);

  Future<Either<Failure, List<Transaction>>> getAllTransactions();

  Future<Either<Failure, Transaction>> getTransactionById(String id);
}