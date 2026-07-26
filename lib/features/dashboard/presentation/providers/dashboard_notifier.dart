import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/usecases/get_dashboard_summary.dart';
import 'dashboard_state.dart';

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    _load();
    return DashboardState.initial();
  }

  Future<void> _load() async {
    try {
      final result = await sl<GetDashboardSummary>().call(
        GetDashboardSummaryParams(
          month: state.selectedMonth,
          year: state.selectedYear,
        ),
      );

      result.match(
        (failure) {
          // ignore: avoid_print
          print('DASHBOARD FAILURE: ${failure.message}');
          state = state.copyWith(
            status: DashboardStatus.error,
            errorMessage: failure.message,
          );
        },
        (summary) {
          // ignore: avoid_print
          print(
            'DASHBOARD SUCCESS: income=${summary.totalIncome} expense=${summary.totalExpense}',
          );
          state = state.copyWith(
            status: DashboardStatus.loaded,
            summary: summary,
          );
        },
      );
    } catch (e, stack) {
      // ignore: avoid_print
      print('DASHBOARD CRASH: $e');
      // ignore: avoid_print
      print(stack);
      state = state.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void goToPreviousMonth() {
    var month = state.selectedMonth - 1;
    var year = state.selectedYear;
    if (month < 1) {
      month = 12;
      year -= 1;
    }
    state = state.copyWith(
      status: DashboardStatus.loading,
      selectedMonth: month,
      selectedYear: year,
    );
    _load();
  }

  void goToNextMonth() {
    var month = state.selectedMonth + 1;
    var year = state.selectedYear;
    if (month > 12) {
      month = 1;
      year += 1;
    }
    state = state.copyWith(
      status: DashboardStatus.loading,
      selectedMonth: month,
      selectedYear: year,
    );
    _load();
  }

  void refresh() {
    state = state.copyWith(status: DashboardStatus.loading);
    _load();
  }
}

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);
