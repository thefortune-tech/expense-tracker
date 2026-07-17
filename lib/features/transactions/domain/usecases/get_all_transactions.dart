import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetAllTransactions implements UseCase<List<Transaction>, NoParams> {
  final TransactionRepository repository;

  const GetAllTransactions(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(NoParams params) {
    return repository.getAllTransactions();
  }
}