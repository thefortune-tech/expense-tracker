import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import 'transaction_validator.dart';

class AddTransactionParams extends Equatable {
  final String id;
  final double amount;
  final String currencyCode;
  final String category;
  final DateTime date;
  final String note;
  final TransactionType type;

  const AddTransactionParams({
    required this.id,
    required this.amount,
    required this.currencyCode,
    required this.category,
    required this.date,
    required this.note,
    required this.type,
  });

  @override
  List<Object> get props => [id, amount, currencyCode, category, date, note, type];
}

class AddTransaction implements UseCase<Transaction, AddTransactionParams> {
  final TransactionRepository repository;

  const AddTransaction(this.repository);

  @override
  Future<Either<Failure, Transaction>> call(AddTransactionParams params) async {
    final validation = TransactionValidator.validate(
      amount: params.amount,
      category: params.category,
      currencyCode: params.currencyCode,
    );

    return validation.match(
      (failure) => Left(failure),
      (_) => repository.addTransaction(
        Transaction(
          id: params.id,
          amount: params.amount,
          currencyCode: params.currencyCode,
          category: params.category,
          date: params.date,
          note: params.note,
          type: params.type,
        ),
      ),
    );
  }
}

