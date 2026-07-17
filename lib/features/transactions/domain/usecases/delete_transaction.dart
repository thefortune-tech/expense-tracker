import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/transaction_repository.dart';

class DeleteTransactionParams extends Equatable {
  final String id;

  const DeleteTransactionParams(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteTransaction implements UseCase<Unit, DeleteTransactionParams> {
  final TransactionRepository repository;

  const DeleteTransaction(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteTransactionParams params) {
    return repository.deleteTransaction(params.id);
  }
}

