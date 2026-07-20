import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_all_transactions.dart';
import '../../domain/usecases/update_transaction.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetAllTransactions getAllTransactions;
  final AddTransaction addTransaction;
  final UpdateTransaction updateTransaction;
  final DeleteTransaction deleteTransaction;

  TransactionBloc({
    required this.getAllTransactions,
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
  }) : super(const TransactionState()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransactionEvent>(_onAddTransaction);
    on<UpdateTransactionEvent>(_onUpdateTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<FilterTransactions>(_onFilterTransactions);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final result = await getAllTransactions(NoParams());

    result.match(
      (failure) => emit(state.copyWith(
        status: TransactionStatus.error,
        errorMessage: failure.message,
      )),
      (transactions) => emit(state.copyWith(
        status: TransactionStatus.loaded,
        allTransactions: transactions,
      )),
    );
  }

  Future<void> _onAddTransaction(
    AddTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    final result = await addTransaction(AddTransactionParams(
      id: const Uuid().v4(),
      amount: event.amount,
      currencyCode: event.currencyCode,
      category: event.category,
      date: event.date,
      note: event.note,
      type: event.type,
    ));

    await result.match(
      (failure) async => emit(state.copyWith(
        status: TransactionStatus.error,
        errorMessage: failure.message,
      )),
      (_) async => _onLoadTransactions(const LoadTransactions(), emit),
    );
  }

  Future<void> _onUpdateTransaction(
    UpdateTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    final result = await updateTransaction(UpdateTransactionParams(
      id: event.id,
      amount: event.amount,
      currencyCode: event.currencyCode,
      category: event.category,
      date: event.date,
      note: event.note,
      type: event.type,
    ));

    await result.match(
      (failure) async => emit(state.copyWith(
        status: TransactionStatus.error,
        errorMessage: failure.message,
      )),
      (_) async => _onLoadTransactions(const LoadTransactions(), emit),
    );
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    final result = await deleteTransaction(DeleteTransactionParams(event.id));

    await result.match(
      (failure) async => emit(state.copyWith(
        status: TransactionStatus.error,
        errorMessage: failure.message,
      )),
      (_) async => _onLoadTransactions(const LoadTransactions(), emit),
    );
  }

  void _onFilterTransactions(
    FilterTransactions event,
    Emitter<TransactionState> emit,
  ) {
    emit(state.copyWith(
      filterCategory: event.category,
      filterType: event.type,
      clearFilterCategory: event.category == null,
      clearFilterType: event.type == null,
    ));
  }
}