import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../budget/domain/repositories/budget_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../entities/category_breakdown.dart';
import '../entities/dashboard_summary.dart';

class GetDashboardSummary implements UseCase<DashboardSummary, GetDashboardSummaryParams> {
  final TransactionRepository transactionRepository;
  final BudgetRepository budgetRepository;

  const GetDashboardSummary(this.transactionRepository, this.budgetRepository);

  @override
  Future<Either<Failure, DashboardSummary>> call(GetDashboardSummaryParams params) async {
    final transactionsResult = await transactionRepository.getAllTransactions();

    return transactionsResult.match(
      (failure) => Left(failure),
      (allTransactions) async {
        final monthTransactions = allTransactions.where((t) {
          return t.date.month == params.month && t.date.year == params.year;
        }).toList();

        final totalIncome = monthTransactions
            .where((t) => t.type == TransactionType.income)
            .fold<double>(0, (sum, t) => sum + t.amount);

        final totalExpense = monthTransactions
            .where((t) => t.type == TransactionType.expense)
            .fold<double>(0, (sum, t) => sum + t.amount);

        final expensesByCategory = <String, double>{};
        for (final t in monthTransactions.where((t) => t.type == TransactionType.expense)) {
          expensesByCategory[t.category] = (expensesByCategory[t.category] ?? 0) + t.amount;
        }

        final breakdowns = <CategoryBreakdown>[];
        for (final entry in expensesByCategory.entries) {
          final budgetResult = await budgetRepository.getBudgetForCategory(
            category: entry.key,
            month: params.month,
            year: params.year,
          );

          final budgetLimit = budgetResult.match(
            (_) => null,
            (budget) => budget?.monthlyLimit,
          );

          breakdowns.add(CategoryBreakdown(
            category: entry.key,
            totalSpent: entry.value,
            budgetLimit: budgetLimit,
            percentageOfTotalSpending: totalExpense == 0 ? 0 : (entry.value / totalExpense) * 100,
          ));
        }

        return Right(DashboardSummary(
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          month: params.month,
          year: params.year,
          categoryBreakdowns: breakdowns,
        ));
      },
    ) as Future<Either<Failure, DashboardSummary>>;
  }
}

class GetDashboardSummaryParams extends Equatable {
  final int month;
  final int year;

  const GetDashboardSummaryParams({required this.month, required this.year});

  @override
  List<Object> get props => [month, year];
}