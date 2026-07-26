import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';

class SetBudgetPage extends StatefulWidget {
  final int month;
  final int year;

  const SetBudgetPage({super.key, required this.month, required this.year});

  @override
  State<SetBudgetPage> createState() => _SetBudgetPageState();
}

class _SetBudgetPageState extends State<SetBudgetPage> {
  final _categoryController = TextEditingController();
  final _limitController = TextEditingController();
  String _currency = 'NGN';

  final _currencies = const ['NGN', 'USD', 'EUR', 'GBP', 'GHS', 'KES', 'ZAR'];

  @override
  void dispose() {
    _categoryController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  void _submit() {
    final category = _categoryController.text.trim();
    final limit = double.tryParse(_limitController.text.trim());

    if (category.isEmpty || limit == null) return;

    context.read<BudgetBloc>().add(
      SetBudgetEvent(
        category: category,
        monthlyLimit: limit,
        currencyCode: _currency,
        month: widget.month,
        year: widget.year,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Budget')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _categoryController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _limitController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Monthly Limit',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _currency,
              dropdownColor: AppColors.surface,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Currency',
                border: OutlineInputBorder(),
              ),
              items: _currencies
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _currency = value);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
