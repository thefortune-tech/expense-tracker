import 'package:hive/hive.dart';

import '../../domain/entities/budget.dart';

class BudgetModel extends Budget {
  const BudgetModel({
    required super.id,
    required super.category,
    required super.monthlyLimit,
    required super.currencyCode,
    required super.month,
    required super.year,
  });

  factory BudgetModel.fromEntity(Budget budget) {
    return BudgetModel(
      id: budget.id,
      category: budget.category,
      monthlyLimit: budget.monthlyLimit,
      currencyCode: budget.currencyCode,
      month: budget.month,
      year: budget.year,
    );
  }

  Budget toEntity() {
    return Budget(
      id: id,
      category: category,
      monthlyLimit: monthlyLimit,
      currencyCode: currencyCode,
      month: month,
      year: year,
    );
  }
}

class BudgetModelAdapter extends TypeAdapter<BudgetModel> {
  @override
  final int typeId = 2;

  @override
  BudgetModel read(BinaryReader reader) {
    final id = reader.readString();
    final category = reader.readString();
    final monthlyLimit = reader.readDouble();
    final currencyCode = reader.readString();
    final month = reader.readInt();
    final year = reader.readInt();

    return BudgetModel(
      id: id,
      category: category,
      monthlyLimit: monthlyLimit,
      currencyCode: currencyCode,
      month: month,
      year: year,
    );
  }

  @override
  void write(BinaryWriter writer, BudgetModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.category);
    writer.writeDouble(obj.monthlyLimit);
    writer.writeString(obj.currencyCode);
    writer.writeInt(obj.month);
    writer.writeInt(obj.year);
  }
}