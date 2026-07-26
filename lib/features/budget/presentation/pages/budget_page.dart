import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';
import '../widgets/budget_progress_bar.dart';
import 'set_budget_page.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return BlocProvider(
      create: (_) =>
          sl<BudgetBloc>()..add(LoadBudgets(month: now.month, year: now.year)),
      child: const _BudgetView(),
    );
  }
}

class _BudgetView extends StatelessWidget {
  const _BudgetView();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Budget')),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          if (state.status == BudgetStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == BudgetStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Something went wrong',
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }
          if (state.budgetUsages.isEmpty) {
            return const Center(
              child: Text(
                'No budgets set for this month',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.budgetUsages.length,
            itemBuilder: (context, index) {
              final usage = state.budgetUsages[index];
              return BudgetProgressBar(
                usage: usage,
                onDelete: () => context.read<BudgetBloc>().add(
                  DeleteBudgetEvent(usage.budget.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<BudgetBloc>(),
              child: SetBudgetPage(month: now.month, year: now.year),
            ),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
