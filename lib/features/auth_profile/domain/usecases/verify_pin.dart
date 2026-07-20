import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class VerifyPin implements UseCase<bool, VerifyPinParams> {
  final ProfileRepository repository;

  const VerifyPin(this.repository);

  @override
  Future<Either<Failure, bool>> call(VerifyPinParams params) {
    if (params.enteredPin.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('PIN cannot be empty')));
    }

    return repository.verifyPin(params.enteredPin);
  }
}

class VerifyPinParams extends Equatable {
  final String enteredPin;

  const VerifyPinParams(this.enteredPin);

  @override
  List<Object> get props => [enteredPin];
}