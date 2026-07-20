import 'package:equatable/equatable.dart';

import '../../domain/entities/user_profile.dart';

enum ProfileStatus {
  loading,
  needsSetup,
  needsPinEntry,
  unlocked,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfile? profile;
  final String? errorMessage;

  const ProfileState({
    required this.status,
    this.profile,
    this.errorMessage,
  });

  const ProfileState.loading() : this(status: ProfileStatus.loading);

  const ProfileState.needsSetup() : this(status: ProfileStatus.needsSetup);

  const ProfileState.needsPinEntry(UserProfile profile)
      : this(status: ProfileStatus.needsPinEntry, profile: profile);

  const ProfileState.unlocked(UserProfile profile)
      : this(status: ProfileStatus.unlocked, profile: profile);

  const ProfileState.error(String message)
      : this(status: ProfileStatus.error, errorMessage: message);

  @override
  List<Object?> get props => [status, profile, errorMessage];
}