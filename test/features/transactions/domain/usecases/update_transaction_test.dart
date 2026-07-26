import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/features/transactions/domain/usecases/update_transaction.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class FakeTransaction extends Fake implements Transaction {}

void main() {
  late UpdateTransaction useCase;
  late MockTransactionRepository mockRepository;
  setUpAll(() {
    registerFallbackValue(FakeTransaction());
  });
  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = UpdateTransaction(mockRepository);
  });

  final tParams = UpdateTransactionParams(
    id: 'existing-id',
    amount: 2500,
    currencyCode: 'NGN',
    category: 'Transport',
    date: DateTime(2026, 7, 21),
    note: 'Uber ride',
    type: TransactionType.expense,
  );

  final tUpdatedTransaction = Transaction(
    id: 'existing-id',
    amount: 2500,
    currencyCode: 'NGN',
    category: 'Transport',
    date: DateTime(2026, 7, 21),
    note: 'Uber ride',
    type: TransactionType.expense,
  );

  group('UpdateTransaction', () {
    test(
      'returns Right(Transaction) when input is valid and repository succeeds',
      () async {
        when(
          () => mockRepository.updateTransaction(any()),
        ).thenAnswer((_) async => Right(tUpdatedTransaction));

        final result = await useCase(tParams);

        expect(result, Right(tUpdatedTransaction));
        verify(() => mockRepository.updateTransaction(any())).called(1);
      },
    );

    test(
      'returns Left(ValidationFailure) when amount is zero, without calling repository',
      () async {
        final invalidParams = UpdateTransactionParams(
          id: 'existing-id',
          amount: 0,
          currencyCode: 'NGN',
          category: 'Transport',
          date: DateTime(2026, 7, 21),
          note: '',
          type: TransactionType.expense,
        );

        final result = await useCase(invalidParams);

        expect(result, isA<Left<Failure, Transaction>>());
        verifyNever(() => mockRepository.updateTransaction(any()));
      },
    );

    test('returns Left(ValidationFailure) when category is empty', () async {
      final invalidParams = UpdateTransactionParams(
        id: 'existing-id',
        amount: 2500,
        currencyCode: 'NGN',
        category: '',
        date: DateTime(2026, 7, 21),
        note: '',
        type: TransactionType.expense,
      );

      final result = await useCase(invalidParams);

      expect(result, isA<Left<Failure, Transaction>>());
      verifyNever(() => mockRepository.updateTransaction(any()));
    });

    test(
      'propagates Left(NotFoundFailure) when repository cannot find the transaction',
      () async {
        when(() => mockRepository.updateTransaction(any())).thenAnswer(
          (_) async => const Left(NotFoundFailure('Transaction not found')),
        );

        final result = await useCase(tParams);

        expect(result, const Left(NotFoundFailure('Transaction not found')));
      },
    );
  });
}
