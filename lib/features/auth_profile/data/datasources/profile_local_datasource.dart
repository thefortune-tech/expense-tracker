import 'package:hive/hive.dart';

import '../models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel> createProfile(UserProfileModel profile);

  Future<UserProfileModel> updateProfile(UserProfileModel profile);

  Future<UserProfileModel?> getCurrentProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const String profileKey = 'current_profile';

  final Box<UserProfileModel> box;

  const ProfileLocalDataSourceImpl(this.box);

  @override
  Future<UserProfileModel> createProfile(UserProfileModel profile) async {
    await box.put(profileKey, profile);
    return profile;
  }

  @override
  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    await box.put(profileKey, profile);
    return profile;
  }

  @override
  Future<UserProfileModel?> getCurrentProfile() async {
    return box.get(profileKey);
  }
}