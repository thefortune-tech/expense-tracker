import 'package:equatable/equatable.dart';

enum TransactionType { expense, income }

class Transaction extends Equatable {
  final String id;
  final double amount;
  final String currencyCode;
  final String category;
  final DateTime date;
  final String note;
  final TransactionType type;

  const Transaction({
    required this.id,
    required this.amount,
    required this.currencyCode,
    required this.category,
    required this.date,
    required this.note,
    required this.type,
  });

  @override
  List<Object> get props => [
        id,
        amount,
        currencyCode,
        category,
        date,
        note,
        type,
      ];
}