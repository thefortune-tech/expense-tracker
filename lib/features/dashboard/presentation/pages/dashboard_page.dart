import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/dashboard_notifier.dart';
import '../providers/dashboard_state.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/summary_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardNotifierProvider);
    final notifier = ref.read(dashboardNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: () async => notifier.refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: notifier.goToPreviousMonth,
                  ),
                  Text(
                    '${_monthNames[state.selectedMonth - 1]} ${state.selectedYear}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: notifier.goToNextMonth,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (state.status == DashboardStatus.loading)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.status == DashboardStatus.error)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.errorMessage ?? 'Something went wrong',
                    style: const TextStyle(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (state.summary != null) ...[
                SummaryCard(
                  totalIncome: state.summary!.totalIncome,
                  totalExpense: state.summary!.totalExpense,
                  netBalance: state.summary!.netBalance,
                  currencyCode: 'NGN',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Spending by Category',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CategoryPieChart(breakdowns: state.summary!.categoryBreakdowns),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}