import 'package:equatable/equatable.dart';

import '../../domain/entities/dashboard_summary.dart';

enum DashboardStatus { loading, loaded, error }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardSummary? summary;
  final String? errorMessage;
  final int selectedMonth;
  final int selectedYear;

  const DashboardState({
    required this.status,
    this.summary,
    this.errorMessage,
    required this.selectedMonth,
    required this.selectedYear,
  });

  DashboardState.initial()
      : this(
          status: DashboardStatus.loading,
          selectedMonth: DateTime.now().month,
          selectedYear: DateTime.now().year,
        );

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardSummary? summary,
    String? errorMessage,
    int? selectedMonth,
    int? selectedYear,
  }) {
    return DashboardState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }

  @override
  List<Object?> get props => [status, summary, errorMessage, selectedMonth, selectedYear];
}