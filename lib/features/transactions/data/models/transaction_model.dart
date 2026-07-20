import 'package:hive/hive.dart';

import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.currencyCode,
    required super.category,
    required super.date,
    required super.note,
    required super.type,
  });

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      amount: transaction.amount,
      currencyCode: transaction.currencyCode,
      category: transaction.category,
      date: transaction.date,
      note: transaction.note,
      type: transaction.type,
    );
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      amount: amount,
      currencyCode: currencyCode,
      category: category,
      date: date,
      note: note,
      type: type,
    );
  }
}

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 0;

  @override
  TransactionModel read(BinaryReader reader) {
    final id = reader.readString();
    final amount = reader.readDouble();
    final currencyCode = reader.readString();
    final category = reader.readString();
    final date = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final note = reader.readString();
    final typeIndex = reader.readInt();

    return TransactionModel(
      id: id,
      amount: amount,
      currencyCode: currencyCode,
      category: category,
      date: date,
      note: note,
      type: TransactionType.values[typeIndex],
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer.writeString(obj.id);
    writer.writeDouble(obj.amount);
    writer.writeString(obj.currencyCode);
    writer.writeString(obj.category);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeString(obj.note);
    writer.writeInt(obj.type.index);
  }
}