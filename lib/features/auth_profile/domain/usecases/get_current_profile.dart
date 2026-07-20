import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetCurrentProfile implements UseCase<UserProfile?, NoParams> {
  final ProfileRepository repository;

  const GetCurrentProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile?>> call(NoParams params) {
    return repository.getCurrentProfile();
  }
}