import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {
  const LoadTransactions();
}

class AddTransactionEvent extends TransactionEvent {
  final double amount;
  final String currencyCode;
  final String category;
  final DateTime date;
  final String note;
  final TransactionType type;

  const AddTransactionEvent({
    required this.amount,
    required this.currencyCode,
    required this.category,
    required this.date,
    required this.note,
    required this.type,
  });

  @override
  List<Object?> get props => [amount, currencyCode, category, date, note, type];
}

class UpdateTransactionEvent extends TransactionEvent {
  final String id;
  final double amount;
  final String currencyCode;
  final String category;
  final DateTime date;
  final String note;
  final TransactionType type;

  const UpdateTransactionEvent({
    required this.id,
    required this.amount,
    required this.currencyCode,
    required this.category,
    required this.date,
    required this.note,
    required this.type,
  });

  @override
  List<Object?> get props => [id, amount, currencyCode, category, date, note, type];
}

class DeleteTransactionEvent extends TransactionEvent {
  final String id;

  const DeleteTransactionEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterTransactions extends TransactionEvent {
  final String? category;
  final TransactionType? type;

  const FilterTransactions({this.category, this.type});

  @override
  List<Object?> get props => [category, type];
}