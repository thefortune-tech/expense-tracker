import 'package:flutter/material.dart';

import '../../../../core/currency/currency_formatter.dart';
import '../../../../core/theme/app_theme.dart';

class SummaryCard extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final String currencyCode;

  const SummaryCard({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Net Balance', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 4),
            Text(
              CurrencyFormatter.format(netBalance, currencyCode),
              style: TextStyle(
                color: netBalance >= 0 ? AppColors.success : AppColors.error,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: 'Income',
                    amount: totalIncome,
                    color: AppColors.success,
                    currencyCode: currencyCode,
                  ),
                ),
                Expanded(
                  child: _MiniStat(
                    label: 'Expense',
                    amount: totalExpense,
                    color: AppColors.error,
                    currencyCode: currencyCode,
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

class _MiniStat extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final String currencyCode;

  const _MiniStat({
    required this.label,
    required this.amount,
    required this.color,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text(
          CurrencyFormatter.format(amount, currencyCode),
          style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ],
    );
  }
}