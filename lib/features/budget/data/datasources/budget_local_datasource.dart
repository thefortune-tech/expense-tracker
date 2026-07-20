import 'package:hive/hive.dart';

import '../../../../core/error/failures.dart';
import '../models/budget_model.dart';

abstract class BudgetLocalDataSource {
  Future<BudgetModel> setBudget(BudgetModel budget);

  Future<void> deleteBudget(String id);

  Future<List<BudgetModel>> getBudgetsForMonth(int month, int year);

  Future<BudgetModel?> getBudgetForCategory({
    required String category,
    required int month,
    required int year,
  });
}

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  final Box<BudgetModel> box;

  const BudgetLocalDataSourceImpl(this.box);

  String _keyFor({required String category, required int month, required int year}) {
    return '${category}_${month}_$year';
  }

  @override
  Future<BudgetModel> setBudget(BudgetModel budget) async {
    final key = _keyFor(category: budget.category, month: budget.month, year: budget.year);
    await box.put(key, budget);
    return budget;
  }

  @override
  Future<void> deleteBudget(String id) async {
    final match = box.values.where((b) => b.id == id);
    if (match.isEmpty) {
      throw const NotFoundFailure('Budget not found');
    }
    final budget = match.first;
    final key = _keyFor(category: budget.category, month: budget.month, year: budget.year);
    await box.delete(key);
  }

  @override
  Future<List<BudgetModel>> getBudgetsForMonth(int month, int year) async {
    return box.values.where((b) => b.month == month && b.year == year).toList();
  }

  @override
  Future<BudgetModel?> getBudgetForCategory({
    required String category,
    required int month,
    required int year,
  }) async {
    final key = _keyFor(category: category, month: month, year: year);
    return box.get(key);
  }
}