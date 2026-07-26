import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/usecases/usecase.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transactions/domain/usecases/add_transaction.dart';
import 'package:expense_tracker/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:expense_tracker/features/transactions/domain/usecases/get_all_transactions.dart';
import 'package:expense_tracker/features/transactions/domain/usecases/update_transaction.dart';
import 'package:expense_tracker/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:expense_tracker/features/transactions/presentation/bloc/transaction_state.dart';

class MockGetAllTransactions extends Mock implements GetAllTransactions {}

class MockAddTransaction extends Mock implements AddTransaction {}

class MockUpdateTransaction extends Mock implements UpdateTransaction {}

class MockDeleteTransaction extends Mock implements DeleteTransaction {}

class FakeAddTransactionParams extends Fake implements AddTransactionParams {}

void main() {
  late MockGetAllTransactions mockGetAllTransactions;
  late MockAddTransaction mockAddTransaction;
  late MockUpdateTransaction mockUpdateTransaction;
  late MockDeleteTransaction mockDeleteTransaction;

  setUpAll(() {
    registerFallbackValue(FakeAddTransactionParams());
    registerFallbackValue(const DeleteTransactionParams('fallback-id'));
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetAllTransactions = MockGetAllTransactions();
    mockAddTransaction = MockAddTransaction();
    mockUpdateTransaction = MockUpdateTransaction();
    mockDeleteTransaction = MockDeleteTransaction();
  });

  TransactionBloc buildBloc() => TransactionBloc(
    getAllTransactions: mockGetAllTransactions,
    addTransaction: mockAddTransaction,
    updateTransaction: mockUpdateTransaction,
    deleteTransaction: mockDeleteTransaction,
  );

  final tTransaction = Transaction(
    id: 't1',
    amount: 1500,
    currencyCode: 'NGN',
    category: 'Food',
    date: DateTime(2026, 7, 20),
    note: 'Lunch',
    type: TransactionType.expense,
  );

  group('TransactionBloc', () {
    blocTest<TransactionBloc, TransactionState>(
      'emits [loading, loaded] with transactions when LoadTransactions succeeds',
      build: () {
        when(
          () => mockGetAllTransactions(any()),
        ).thenAnswer((_) async => Right([tTransaction]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadTransactions()),
      expect: () => [
        const TransactionState(status: TransactionStatus.loading),
        TransactionState(
          status: TransactionStatus.loaded,
          allTransactions: [tTransaction],
        ),
      ],
    );

    blocTest<TransactionBloc, TransactionState>(
      'emits [loading, error] when LoadTransactions fails',
      build: () {
        when(
          () => mockGetAllTransactions(any()),
        ).thenAnswer((_) async => const Left(CacheFailure('Hive read error')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadTransactions()),
      expect: () => [
        const TransactionState(status: TransactionStatus.loading),
        const TransactionState(
          status: TransactionStatus.error,
          errorMessage: 'Hive read error',
        ),
      ],
    );

    blocTest<TransactionBloc, TransactionState>(
      'reloads the list after a successful AddTransactionEvent',
      build: () {
        when(
          () => mockAddTransaction(any()),
        ).thenAnswer((_) async => Right(tTransaction));
        when(
          () => mockGetAllTransactions(any()),
        ).thenAnswer((_) async => Right([tTransaction]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        AddTransactionEvent(
          amount: 1500,
          currencyCode: 'NGN',
          category: 'Food',
          date: DateTime(2026, 7, 20),
          note: 'Lunch',
          type: TransactionType.expense,
        ),
      ),
      expect: () => [
        const TransactionState(status: TransactionStatus.loading),
        TransactionState(
          status: TransactionStatus.loaded,
          allTransactions: [tTransaction],
        ),
      ],
      verify: (_) {
        verify(() => mockAddTransaction(any())).called(1);
        verify(() => mockGetAllTransactions(any())).called(1);
      },
    );

    blocTest<TransactionBloc, TransactionState>(
      'emits error and does not reload when AddTransactionEvent fails validation',
      build: () {
        when(() => mockAddTransaction(any())).thenAnswer(
          (_) async =>
              const Left(ValidationFailure('Amount must be greater than zero')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        AddTransactionEvent(
          amount: 0,
          currencyCode: 'NGN',
          category: 'Food',
          date: DateTime(2026, 7, 20),
          note: '',
          type: TransactionType.expense,
        ),
      ),
      expect: () => [
        const TransactionState(
          status: TransactionStatus.error,
          errorMessage: 'Amount must be greater than zero',
        ),
      ],
      verify: (_) {
        verifyNever(() => mockGetAllTransactions(any()));
      },
    );

    blocTest<TransactionBloc, TransactionState>(
      'reloads the list after a successful DeleteTransactionEvent',
      build: () {
        when(
          () => mockDeleteTransaction(any()),
        ).thenAnswer((_) async => const Right(unit));
        when(
          () => mockGetAllTransactions(any()),
        ).thenAnswer((_) async => const Right([]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const DeleteTransactionEvent('t1')),
      expect: () => [
        const TransactionState(status: TransactionStatus.loading),
        const TransactionState(
          status: TransactionStatus.loaded,
          allTransactions: [],
        ),
      ],
    );

    blocTest<TransactionBloc, TransactionState>(
      'FilterTransactions updates filter fields without calling any use case',
      build: buildBloc,
      act: (bloc) =>
          bloc.add(const FilterTransactions(type: TransactionType.income)),
      expect: () => [
        const TransactionState(filterType: TransactionType.income),
      ],
      verify: (_) {
        verifyNever(() => mockGetAllTransactions(any()));
        verifyNever(() => mockAddTransaction(any()));
      },
    );
  });
}
