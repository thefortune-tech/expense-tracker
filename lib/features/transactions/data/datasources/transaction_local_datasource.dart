import 'package:hive/hive.dart';

import '../../../../core/error/failures.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<TransactionModel> addTransaction(TransactionModel transaction);

  Future<TransactionModel> updateTransaction(TransactionModel transaction);

  Future<void> deleteTransaction(String id);

  Future<List<TransactionModel>> getAllTransactions();

  Future<TransactionModel> getTransactionById(String id);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Box<TransactionModel> box;

  const TransactionLocalDataSourceImpl(this.box);

  @override
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    await box.put(transaction.id, transaction);
    return transaction;
  }

  @override
  Future<TransactionModel> updateTransaction(TransactionModel transaction) async {
    if (!box.containsKey(transaction.id)) {
      throw const NotFoundFailure('Transaction not found');
    }
    await box.put(transaction.id, transaction);
    return transaction;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    if (!box.containsKey(id)) {
      throw const NotFoundFailure('Transaction not found');
    }
    await box.delete(id);
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    return box.values.toList();
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    final transaction = box.get(id);
    if (transaction == null) {
      throw const NotFoundFailure('Transaction not found');
    }
    return transaction;
  }
}