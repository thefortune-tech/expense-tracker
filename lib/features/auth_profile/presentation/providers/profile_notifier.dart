import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/create_profile.dart';
import '../../domain/usecases/get_current_profile.dart';
import '../../domain/usecases/verify_pin.dart';
import 'profile_state.dart';

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    _checkCurrentProfile();
    return const ProfileState.loading();
  }

  Future<void> _checkCurrentProfile() async {
    final result = await sl<GetCurrentProfile>().call(NoParams());

    result.match(
      (failure) => state = ProfileState.error(failure.message),
      (profile) {
        if (profile == null) {
          state = const ProfileState.needsSetup();
        } else if (profile.hasPin) {
          state = ProfileState.needsPinEntry(profile);
        } else {
          state = ProfileState.unlocked(profile);
        }
      },
    );
  }

  Future<void> createProfile({
    required String name,
    String? pin,
    required String defaultCurrencyCode,
  }) async {
    state = const ProfileState.loading();

    final result = await sl<CreateProfile>().call(
      CreateProfileParams(
        id: const Uuid().v4(),
        name: name,
        pin: pin,
        defaultCurrencyCode: defaultCurrencyCode,
        createdAt: DateTime.now(),
      ),
    );

    result.match(
      (failure) => state = ProfileState.error(failure.message),
      (profile) => state = ProfileState.unlocked(profile),
    );
  }

  Future<void> verifyPin(String enteredPin) async {
    final currentProfile = state.profile;
    if (currentProfile == null) return;

    final result = await sl<VerifyPin>().call(VerifyPinParams(enteredPin));

    result.match(
      (failure) => state = ProfileState.error(failure.message),
      (isCorrect) {
        if (isCorrect) {
          state = ProfileState.unlocked(currentProfile);
        } else {
          state = ProfileState.needsPinEntry(currentProfile);
        }
      },
    );
  }
}

final profileNotifierProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);