import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

class BudgetValidator {
  static Either<Failure, Unit> validate({
    required String category,
    required double monthlyLimit,
    required String currencyCode,
    required int month,
    required int year,
  }) {
    if (category.trim().isEmpty) {
      return const Left(ValidationFailure('Category cannot be empty'));
    }
    if (monthlyLimit <= 0) {
      return const Left(ValidationFailure('Monthly limit must be greater than zero'));
    }
    if (currencyCode.trim().isEmpty) {
      return const Left(ValidationFailure('Currency must be selected'));
    }
    if (month < 1 || month > 12) {
      return const Left(ValidationFailure('Month must be between 1 and 12'));
    }
    if (year < 2000) {
      return const Left(ValidationFailure('Year is invalid'));
    }
    return const Right(unit);
  }
}