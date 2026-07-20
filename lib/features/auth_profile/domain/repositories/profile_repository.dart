import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> createProfile(UserProfile profile);

  Future<Either<Failure, UserProfile>> updateProfile(UserProfile profile);

  Future<Either<Failure, UserProfile?>> getCurrentProfile();

  Future<Either<Failure, bool>> verifyPin(String enteredPin);
}