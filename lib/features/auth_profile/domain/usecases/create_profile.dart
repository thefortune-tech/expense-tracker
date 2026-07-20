import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class CreateProfileParams extends Equatable {
  final String id;
  final String name;
  final String? pin;
  final String defaultCurrencyCode;
  final DateTime createdAt;

  const CreateProfileParams({
    required this.id,
    required this.name,
    this.pin,
    required this.defaultCurrencyCode,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, pin, defaultCurrencyCode, createdAt];
}

class CreateProfile implements UseCase<UserProfile, CreateProfileParams> {
  final ProfileRepository repository;

  const CreateProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(CreateProfileParams params) async {
    if (params.name.trim().isEmpty) {
      return const Left(ValidationFailure('Name cannot be empty'));
    }

    if (params.pin != null && params.pin!.isNotEmpty) {
      final pin = params.pin!;
      if (pin.length != 4 || int.tryParse(pin) == null) {
        return const Left(ValidationFailure('PIN must be exactly 4 digits'));
      }
    }

    if (params.defaultCurrencyCode.trim().isEmpty) {
      return const Left(ValidationFailure('Default currency must be selected'));
    }

    final profile = UserProfile(
      id: params.id,
      name: params.name.trim(),
      pin: params.pin,
      defaultCurrencyCode: params.defaultCurrencyCode,
      createdAt: params.createdAt,
    );

    return repository.createProfile(profile);
  }
}

