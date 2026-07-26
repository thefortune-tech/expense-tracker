import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/features/transactions/domain/usecases/add_transaction.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class FakeTransaction extends Fake implements Transaction {}

void main() {
  late AddTransaction useCase;
  late MockTransactionRepository mockRepository;
  setUpAll(() {
    registerFallbackValue(FakeTransaction());
  });

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = AddTransaction(mockRepository);
  });

  final tParams = AddTransactionParams(
    id: 'test-id',
    amount: 1000,
    currencyCode: 'NGN',
    category: 'Food',
    date: DateTime(2026, 7, 20),
    note: 'Lunch',
    type: TransactionType.expense,
  );

  final tTransaction = Transaction(
    id: 'test-id',
    amount: 1000,
    currencyCode: 'NGN',
    category: 'Food',
    date: DateTime(2026, 7, 20),
    note: 'Lunch',
    type: TransactionType.expense,
  );

  group('AddTransaction', () {
    test(
      'returns Right(Transaction) when input is valid and repository succeeds',
      () async {
        when(
          () => mockRepository.addTransaction(any()),
        ).thenAnswer((_) async => Right(tTransaction));

        final result = await useCase(tParams);

        expect(result, Right(tTransaction));
        verify(() => mockRepository.addTransaction(any())).called(1);
      },
    );

    test(
      'returns Left(ValidationFailure) when amount is zero, without calling repository',
      () async {
        final invalidParams = AddTransactionParams(
          id: 'test-id',
          amount: 0,
          currencyCode: 'NGN',
          category: 'Food',
          date: DateTime(2026, 7, 20),
          note: '',
          type: TransactionType.expense,
        );

        final result = await useCase(invalidParams);

        expect(result, isA<Left<Failure, Transaction>>());
        verifyNever(() => mockRepository.addTransaction(any()));
      },
    );

    test('returns Left(ValidationFailure) when amount is negative', () async {
      final invalidParams = AddTransactionParams(
        id: 'test-id',
        amount: -50,
        currencyCode: 'NGN',
        category: 'Food',
        date: DateTime(2026, 7, 20),
        note: '',
        type: TransactionType.expense,
      );

      final result = await useCase(invalidParams);

      expect(result, isA<Left<Failure, Transaction>>());
      verifyNever(() => mockRepository.addTransaction(any()));
    });

    test('returns Left(ValidationFailure) when category is empty', () async {
      final invalidParams = AddTransactionParams(
        id: 'test-id',
        amount: 1000,
        currencyCode: 'NGN',
        category: '   ',
        date: DateTime(2026, 7, 20),
        note: '',
        type: TransactionType.expense,
      );

      final result = await useCase(invalidParams);

      expect(result, isA<Left<Failure, Transaction>>());
      verifyNever(() => mockRepository.addTransaction(any()));
    });

    test(
      'returns Left(ValidationFailure) when currencyCode is empty',
      () async {
        final invalidParams = AddTransactionParams(
          id: 'test-id',
          amount: 1000,
          currencyCode: '',
          category: 'Food',
          date: DateTime(2026, 7, 20),
          note: '',
          type: TransactionType.expense,
        );

        final result = await useCase(invalidParams);

        expect(result, isA<Left<Failure, Transaction>>());
        verifyNever(() => mockRepository.addTransaction(any()));
      },
    );

    test('propagates Left(CacheFailure) when repository fails', () async {
      when(
        () => mockRepository.addTransaction(any()),
      ).thenAnswer((_) async => const Left(CacheFailure('Hive write error')));

      final result = await useCase(tParams);

      expect(result, const Left(CacheFailure('Hive write error')));
    });
  });
}
