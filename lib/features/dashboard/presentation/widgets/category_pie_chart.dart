import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/category_breakdown.dart';

class CategoryPieChart extends StatelessWidget {
  final List<CategoryBreakdown> breakdowns;

  const CategoryPieChart({super.key, required this.breakdowns});

  static const List<Color> _palette = [
    AppColors.accent,
    AppColors.success,
    AppColors.error,
    Color(0xFFF2A950),
    Color(0xFF9B6BD9),
    Color(0xFF4FC3D9),
  ];

  @override
  Widget build(BuildContext context) {
    if (breakdowns.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: Text('No expenses this month', style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: List.generate(breakdowns.length, (i) {
                  final b = breakdowns[i];
                  return PieChartSectionData(
                    value: b.totalSpent,
                    color: _palette[i % _palette.length],
                    title: '${b.percentageOfTotalSpending.toStringAsFixed(0)}%',
                    radius: 55,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: breakdowns.length,
              itemBuilder: (context, i) {
                final b = breakdowns[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _palette[i % _palette.length],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          b.category,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}