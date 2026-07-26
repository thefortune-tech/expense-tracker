import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/features/transactions/domain/usecases/delete_transaction.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late DeleteTransaction useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = DeleteTransaction(mockRepository);
  });

  const tParams = DeleteTransactionParams('existing-id');

  group('DeleteTransaction', () {
    test('returns Right(unit) when repository successfully deletes', () async {
      when(
        () => mockRepository.deleteTransaction(any()),
      ).thenAnswer((_) async => const Right(unit));

      final result = await useCase(tParams);

      expect(result, const Right(unit));
      verify(() => mockRepository.deleteTransaction('existing-id')).called(1);
    });

    test(
      'propagates Left(NotFoundFailure) when transaction does not exist',
      () async {
        when(() => mockRepository.deleteTransaction(any())).thenAnswer(
          (_) async => const Left(NotFoundFailure('Transaction not found')),
        );

        final result = await useCase(tParams);

        expect(result, const Left(NotFoundFailure('Transaction not found')));
      },
    );

    test('calls repository with the exact id from params', () async {
      when(
        () => mockRepository.deleteTransaction(any()),
      ).thenAnswer((_) async => const Right(unit));

      await useCase(const DeleteTransactionParams('specific-id-123'));

      verify(
        () => mockRepository.deleteTransaction('specific-id-123'),
      ).called(1);
    });
  });
}
