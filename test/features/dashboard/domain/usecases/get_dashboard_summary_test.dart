import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/budget/domain/entities/budget.dart';
import 'package:expense_tracker/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_tracker/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:expense_tracker/features/dashboard/domain/usecases/get_dashboard_summary.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transactions/domain/repositories/transaction_repository.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

void main() {
  late GetDashboardSummary useCase;
  late MockTransactionRepository mockTransactionRepository;
  late MockBudgetRepository mockBudgetRepository;

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    mockBudgetRepository = MockBudgetRepository();
    useCase = GetDashboardSummary(
      mockTransactionRepository,
      mockBudgetRepository,
    );
  });

  final tParams = GetDashboardSummaryParams(month: 7, year: 2026);

  final tFoodBudget = Budget(
    id: 'b1',
    category: 'Food',
    monthlyLimit: 10000,
    currencyCode: 'NGN',
    month: 7,
    year: 2026,
  );

  List<Transaction> buildTransactions() => [
    Transaction(
      id: 't1',
      amount: 5000,
      currencyCode: 'NGN',
      category: 'Food',
      date: DateTime(2026, 7, 10),
      note: '',
      type: TransactionType.expense,
    ),
    Transaction(
      id: 't2',
      amount: 2000,
      currencyCode: 'NGN',
      category: 'Transport',
      date: DateTime(2026, 7, 12),
      note: '',
      type: TransactionType.expense,
    ),
    Transaction(
      id: 't3',
      amount: 100000,
      currencyCode: 'NGN',
      category: 'Salary',
      date: DateTime(2026, 7, 1),
      note: '',
      type: TransactionType.income,
    ),
    Transaction(
      id: 't4',
      amount: 999999,
      currencyCode: 'NGN',
      category: 'Food',
      date: DateTime(2026, 6, 15),
      note: 'last month, should be excluded',
      type: TransactionType.expense,
    ),
  ];

  group('GetDashboardSummary', () {
    test(
      'correctly aggregates income, expense, and category breakdowns for the given month',
      () async {
        when(
          () => mockTransactionRepository.getAllTransactions(),
        ).thenAnswer((_) async => Right(buildTransactions()));
        when(
          () => mockBudgetRepository.getBudgetForCategory(
            category: 'Food',
            month: 7,
            year: 2026,
          ),
        ).thenAnswer((_) async => Right(tFoodBudget));
        when(
          () => mockBudgetRepository.getBudgetForCategory(
            category: 'Transport',
            month: 7,
            year: 2026,
          ),
        ).thenAnswer((_) async => const Right(null));

        final result = await useCase(tParams);

        expect(result.isRight(), true);

        final summary = result.match((_) => null, (r) => r) as DashboardSummary;

        expect(summary.totalIncome, 100000);
        expect(summary.totalExpense, 7000);
        expect(summary.netBalance, 93000);
        expect(summary.categoryBreakdowns.length, 2);

        final foodBreakdown = summary.categoryBreakdowns.firstWhere(
          (b) => b.category == 'Food',
        );
        expect(foodBreakdown.totalSpent, 5000);
        expect(foodBreakdown.budgetLimit, 10000);

        final transportBreakdown = summary.categoryBreakdowns.firstWhere(
          (b) => b.category == 'Transport',
        );
        expect(transportBreakdown.totalSpent, 2000);
        expect(transportBreakdown.budgetLimit, null);
      },
    );

    test('excludes transactions from other months', () async {
      when(
        () => mockTransactionRepository.getAllTransactions(),
      ).thenAnswer((_) async => Right(buildTransactions()));
      when(
        () => mockBudgetRepository.getBudgetForCategory(
          category: any(named: 'category'),
          month: any(named: 'month'),
          year: any(named: 'year'),
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(tParams);
      final summary = result.match((_) => null, (r) => r) as DashboardSummary;

      final totalSpentAcrossCategories = summary.categoryBreakdowns
          .fold<double>(0, (sum, b) => sum + b.totalSpent);

      expect(totalSpentAcrossCategories, 7000);
    });

    test(
      'returns Left(Failure) when transaction repository fails, without calling budget repository',
      () async {
        when(
          () => mockTransactionRepository.getAllTransactions(),
        ).thenAnswer((_) async => const Left(CacheFailure('Hive read error')));

        final result = await useCase(tParams);

        expect(result, const Left(CacheFailure('Hive read error')));
        verifyNever(
          () => mockBudgetRepository.getBudgetForCategory(
            category: any(named: 'category'),
            month: any(named: 'month'),
            year: any(named: 'year'),
          ),
        );
      },
    );

    test(
      'returns zero totals and empty breakdowns when there are no transactions for the month',
      () async {
        when(
          () => mockTransactionRepository.getAllTransactions(),
        ).thenAnswer((_) async => const Right([]));

        final result = await useCase(tParams);
        final summary = result.match((_) => null, (r) => r) as DashboardSummary;

        expect(summary.totalIncome, 0);
        expect(summary.totalExpense, 0);
        expect(summary.categoryBreakdowns, isEmpty);
      },
    );
  });
}
