import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

class TransactionValidator {
  static Either<Failure, Unit> validate({
    required double amount,
    required String category,
    required String currencyCode,
  }) {
    if (amount <= 0) {
      return const Left(ValidationFailure('Amount must be greater than zero'));
    }

    if (category.trim().isEmpty) {
      return const Left(ValidationFailure('Category cannot be empty'));
    }

    if (currencyCode.trim().isEmpty) {
      return const Left(ValidationFailure('Currency must be selected'));
    }

    return const Right(unit);
  }
}