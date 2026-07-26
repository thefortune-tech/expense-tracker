import 'package:flutter/material.dart';

import '../../../../core/currency/currency_formatter.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/budget_state.dart';

class BudgetProgressBar extends StatelessWidget {
  final BudgetUsage usage;
  final VoidCallback onDelete;

  const BudgetProgressBar({
    super.key,
    required this.usage,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final percent = usage.usagePercent.clamp(0, 100) / 100;
    final barColor = usage.isOverBudget ? AppColors.error : AppColors.accent;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  usage.budget.category,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: percent.toDouble(),
                minHeight: 8,
                backgroundColor: AppColors.surface,
                valueColor: AlwaysStoppedAnimation(barColor),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${CurrencyFormatter.format(usage.spent, usage.budget.currencyCode)} of ${CurrencyFormatter.format(usage.budget.monthlyLimit, usage.budget.currencyCode)}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${usage.usagePercent.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: barColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
