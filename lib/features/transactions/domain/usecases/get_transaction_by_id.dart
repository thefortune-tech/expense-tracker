import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionByIdParams extends Equatable {
  final String id;

  const GetTransactionByIdParams(this.id);

  @override
  List<Object> get props => [id];
}

class GetTransactionById implements UseCase<Transaction, GetTransactionByIdParams> {
  final TransactionRepository repository;

  const GetTransactionById(this.repository);

  @override
  Future<Either<Failure, Transaction>> call(GetTransactionByIdParams params) {
    return repository.getTransactionById(params.id);
  }
}

