import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  const ProfileRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, UserProfile>> createProfile(UserProfile profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      final result = await localDataSource.createProfile(model);
      return Right(result.toEntity());
    } on HiveError catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(UserProfile profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      final result = await localDataSource.updateProfile(model);
      return Right(result.toEntity());
    } on HiveError catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile?>> getCurrentProfile() async {
    try {
      final model = await localDataSource.getCurrentProfile();
      return Right(model?.toEntity());
    } on HiveError catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPin(String enteredPin) async {
    try {
      final model = await localDataSource.getCurrentProfile();

      if (model == null) {
        return const Left(NotFoundFailure('No profile exists to verify against'));
      }

      if (!model.hasPin) {
        return const Left(ValidationFailure('This profile has no PIN set'));
      }

      return Right(model.pin == enteredPin);
    } on HiveError catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}