import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/usecases/get_all_transactions.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/delete_budget.dart';
import '../../domain/usecases/get_budgets_for_month.dart';
import '../../domain/usecases/set_budget.dart';
import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final GetBudgetsForMonth getBudgetsForMonth;
  final SetBudget setBudget;
  final DeleteBudget deleteBudget;
  final GetAllTransactions getAllTransactions;

  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  BudgetBloc({
    required this.getBudgetsForMonth,
    required this.setBudget,
    required this.deleteBudget,
    required this.getAllTransactions,
  }) : super(const BudgetState()) {
    on<LoadBudgets>(_onLoadBudgets);
    on<SetBudgetEvent>(_onSetBudget);
    on<DeleteBudgetEvent>(_onDeleteBudget);
  }

  Future<void> _onLoadBudgets(
    LoadBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));
    _currentMonth = event.month;
    _currentYear = event.year;

    final budgetsResult = await getBudgetsForMonth(
      GetBudgetsForMonthParams(month: event.month, year: event.year),
    );
    final transactionsResult = await getAllTransactions(NoParams());

    budgetsResult.match(
      (failure) => emit(
        state.copyWith(
          status: BudgetStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (budgets) {
        transactionsResult.match(
          (failure) => emit(
            state.copyWith(
              status: BudgetStatus.error,
              errorMessage: failure.message,
            ),
          ),
          (transactions) {
            final monthExpenses = transactions.where(
              (t) =>
                  t.type == TransactionType.expense &&
                  t.date.month == event.month &&
                  t.date.year == event.year,
            );

            final usages = budgets.map((b) {
              final spent = monthExpenses
                  .where((t) => t.category == b.category)
                  .fold<double>(0, (sum, t) => sum + t.amount);
              return BudgetUsage(budget: b, spent: spent);
            }).toList();

            emit(
              state.copyWith(status: BudgetStatus.loaded, budgetUsages: usages),
            );
          },
        );
      },
    );
  }

  Future<void> _onSetBudget(
    SetBudgetEvent event,
    Emitter<BudgetState> emit,
  ) async {
    final result = await setBudget(
      SetBudgetParams(
        id: const Uuid().v4(),
        category: event.category,
        monthlyLimit: event.monthlyLimit,
        currencyCode: event.currencyCode,
        month: event.month,
        year: event.year,
      ),
    );

    await result.match(
      (failure) async => emit(
        state.copyWith(
          status: BudgetStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) async => _onLoadBudgets(
        LoadBudgets(month: _currentMonth, year: _currentYear),
        emit,
      ),
    );
  }

  Future<void> _onDeleteBudget(
    DeleteBudgetEvent event,
    Emitter<BudgetState> emit,
  ) async {
    final result = await deleteBudget(DeleteBudgetParams(event.id));

    await result.match(
      (failure) async => emit(
        state.copyWith(
          status: BudgetStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) async => _onLoadBudgets(
        LoadBudgets(month: _currentMonth, year: _currentYear),
        emit,
      ),
    );
  }
}
