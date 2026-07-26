import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/budget/domain/entities/budget.dart';
import 'package:expense_tracker/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_tracker/features/budget/domain/usecases/set_budget.dart';

class MockBudgetRepository extends Mock implements BudgetRepository {}

class FakeBudget extends Fake implements Budget {}

void main() {
  late SetBudget useCase;
  late MockBudgetRepository mockRepository;
  setUpAll(() {
    registerFallbackValue(FakeBudget());
  });
  setUp(() {
    mockRepository = MockBudgetRepository();
    useCase = SetBudget(mockRepository);
  });

  final tBudget = Budget(
    id: 'budget-id',
    category: 'Food',
    monthlyLimit: 50000,
    currencyCode: 'NGN',
    month: 7,
    year: 2026,
  );

  final tParams = SetBudgetParams(
    id: 'budget-id',
    category: 'Food',
    monthlyLimit: 50000,
    currencyCode: 'NGN',
    month: 7,
    year: 2026,
  );

  group('SetBudget', () {
    test(
      'returns Right(Budget) when input is valid and repository succeeds',
      () async {
        when(
          () => mockRepository.setBudget(any()),
        ).thenAnswer((_) async => Right(tBudget));

        final result = await useCase(tParams);

        expect(result, Right(tBudget));
        verify(() => mockRepository.setBudget(any())).called(1);
      },
    );

    test('returns Left(ValidationFailure) when monthlyLimit is zero', () async {
      final invalidParams = SetBudgetParams(
        id: 'budget-id',
        category: 'Food',
        monthlyLimit: 0,
        currencyCode: 'NGN',
        month: 7,
        year: 2026,
      );

      final result = await useCase(invalidParams);

      expect(result, isA<Left<Failure, Budget>>());
      verifyNever(() => mockRepository.setBudget(any()));
    });

    test('returns Left(ValidationFailure) when category is empty', () async {
      final invalidParams = SetBudgetParams(
        id: 'budget-id',
        category: '  ',
        monthlyLimit: 50000,
        currencyCode: 'NGN',
        month: 7,
        year: 2026,
      );

      final result = await useCase(invalidParams);

      expect(result, isA<Left<Failure, Budget>>());
      verifyNever(() => mockRepository.setBudget(any()));
    });

    test(
      'returns Left(ValidationFailure) when month is out of range (0)',
      () async {
        final invalidParams = SetBudgetParams(
          id: 'budget-id',
          category: 'Food',
          monthlyLimit: 50000,
          currencyCode: 'NGN',
          month: 0,
          year: 2026,
        );

        final result = await useCase(invalidParams);

        expect(result, isA<Left<Failure, Budget>>());
        verifyNever(() => mockRepository.setBudget(any()));
      },
    );

    test(
      'returns Left(ValidationFailure) when month is out of range (13)',
      () async {
        final invalidParams = SetBudgetParams(
          id: 'budget-id',
          category: 'Food',
          monthlyLimit: 50000,
          currencyCode: 'NGN',
          month: 13,
          year: 2026,
        );

        final result = await useCase(invalidParams);

        expect(result, isA<Left<Failure, Budget>>());
        verifyNever(() => mockRepository.setBudget(any()));
      },
    );

    test('returns Left(ValidationFailure) when year is invalid', () async {
      final invalidParams = SetBudgetParams(
        id: 'budget-id',
        category: 'Food',
        monthlyLimit: 50000,
        currencyCode: 'NGN',
        month: 7,
        year: 1999,
      );

      final result = await useCase(invalidParams);

      expect(result, isA<Left<Failure, Budget>>());
      verifyNever(() => mockRepository.setBudget(any()));
    });
  });
}
