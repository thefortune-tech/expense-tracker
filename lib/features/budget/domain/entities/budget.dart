import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final String id;
  final String category;
  final double monthlyLimit;
  final String currencyCode;
  final int month;
  final int year;

  const Budget({
    required this.id,
    required this.category,
    required this.monthlyLimit,
    required this.currencyCode,
    required this.month,
    required this.year,
  });

  @override
  List<Object> get props => [id, category, monthlyLimit, currencyCode, month, year];
}