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
    state = state.copyWith(status: DashboardStatus.loading);

    final result = await sl<GetDashboardSummary>().call(
      GetDashboardSummaryParams(month: state.selectedMonth, year: state.selectedYear),
    );

    result.match(
      (failure) => state = state.copyWith(
        status: DashboardStatus.error,
        errorMessage: failure.message,
      ),
      (summary) => state = state.copyWith(
        status: DashboardStatus.loaded,
        summary: summary,
      ),
    );
  }

  void goToPreviousMonth() {
    var month = state.selectedMonth - 1;
    var year = state.selectedYear;
    if (month < 1) {
      month = 12;
      year -= 1;
    }
    state = state.copyWith(selectedMonth: month, selectedYear: year);
    _load();
  }

  void goToNextMonth() {
    var month = state.selectedMonth + 1;
    var year = state.selectedYear;
    if (month > 12) {
      month = 1;
      year += 1;
    }
    state = state.copyWith(selectedMonth: month, selectedYear: year);
    _load();
  }

  void refresh() => _load();
}

final dashboardNotifierProvider = NotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);