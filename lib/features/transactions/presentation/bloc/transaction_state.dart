import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction.dart';

enum TransactionStatus { initial, loading, loaded, error }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<Transaction> allTransactions;
  final String? filterCategory;
  final TransactionType? filterType;
  final String? errorMessage;

  const TransactionState({
    this.status = TransactionStatus.initial,
    this.allTransactions = const [],
    this.filterCategory,
    this.filterType,
    this.errorMessage,
  });

  List<Transaction> get filteredTransactions {
    return allTransactions.where((t) {
      final matchesCategory = filterCategory == null || t.category == filterCategory;
      final matchesType = filterType == null || t.type == filterType;
      return matchesCategory && matchesType;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Map<String, List<Transaction>> get groupedByDay {
    final grouped = <String, List<Transaction>>{};
    for (final t in filteredTransactions) {
      final key = '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(t);
    }
    return grouped;
  }

  TransactionState copyWith({
    TransactionStatus? status,
    List<Transaction>? allTransactions,
    String? filterCategory,
    TransactionType? filterType,
    String? errorMessage,
    bool clearFilterCategory = false,
    bool clearFilterType = false,
  }) {
    return TransactionState(
      status: status ?? this.status,
      allTransactions: allTransactions ?? this.allTransactions,
      filterCategory: clearFilterCategory ? null : (filterCategory ?? this.filterCategory),
      filterType: clearFilterType ? null : (filterType ?? this.filterType),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, allTransactions, filterCategory, filterType, errorMessage];
}