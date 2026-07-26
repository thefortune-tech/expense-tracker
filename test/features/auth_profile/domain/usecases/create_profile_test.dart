import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/auth_profile/domain/entities/user_profile.dart';
import 'package:expense_tracker/features/auth_profile/domain/repositories/profile_repository.dart';
import 'package:expense_tracker/features/auth_profile/domain/usecases/create_profile.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class FakeUserProfile extends Fake implements UserProfile {}

void main() {
  late CreateProfile useCase;
  late MockProfileRepository mockRepository;
  setUpAll(() {
    registerFallbackValue(FakeUserProfile());
  });
  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = CreateProfile(mockRepository);
  });

  final tCreatedAt = DateTime(2026, 7, 20);

  final tProfileNoPin = UserProfile(
    id: 'profile-id',
    name: 'Adeyemi',
    pin: null,
    defaultCurrencyCode: 'NGN',
    createdAt: tCreatedAt,
  );

  final tProfileWithPin = UserProfile(
    id: 'profile-id',
    name: 'Adeyemi',
    pin: '1234',
    defaultCurrencyCode: 'NGN',
    createdAt: tCreatedAt,
  );

  group('CreateProfile', () {
    test(
      'returns Right(UserProfile) when name is valid and pin is null',
      () async {
        when(
          () => mockRepository.createProfile(any()),
        ).thenAnswer((_) async => Right(tProfileNoPin));

        final result = await useCase(
          CreateProfileParams(
            id: 'profile-id',
            name: 'Adeyemi',
            pin: null,
            defaultCurrencyCode: 'NGN',
            createdAt: tCreatedAt,
          ),
        );

        expect(result, Right(tProfileNoPin));
        verify(() => mockRepository.createProfile(any())).called(1);
      },
    );

    test(
      'returns Right(UserProfile) when a valid 4-digit pin is provided',
      () async {
        when(
          () => mockRepository.createProfile(any()),
        ).thenAnswer((_) async => Right(tProfileWithPin));

        final result = await useCase(
          CreateProfileParams(
            id: 'profile-id',
            name: 'Adeyemi',
            pin: '1234',
            defaultCurrencyCode: 'NGN',
            createdAt: tCreatedAt,
          ),
        );

        expect(result, Right(tProfileWithPin));
        verify(() => mockRepository.createProfile(any())).called(1);
      },
    );

    test(
      'returns Right(UserProfile) when pin is an empty string (treated as no pin)',
      () async {
        when(
          () => mockRepository.createProfile(any()),
        ).thenAnswer((_) async => Right(tProfileNoPin));

        final result = await useCase(
          CreateProfileParams(
            id: 'profile-id',
            name: 'Adeyemi',
            pin: '',
            defaultCurrencyCode: 'NGN',
            createdAt: tCreatedAt,
          ),
        );

        expect(result, isA<Right<Failure, UserProfile>>());
        verify(() => mockRepository.createProfile(any())).called(1);
      },
    );

    test('returns Left(ValidationFailure) when name is empty', () async {
      final result = await useCase(
        CreateProfileParams(
          id: 'profile-id',
          name: '   ',
          pin: null,
          defaultCurrencyCode: 'NGN',
          createdAt: tCreatedAt,
        ),
      );

      expect(result, isA<Left<Failure, UserProfile>>());
      verifyNever(() => mockRepository.createProfile(any()));
    });

    test(
      'returns Left(ValidationFailure) when pin is not exactly 4 digits',
      () async {
        final result = await useCase(
          CreateProfileParams(
            id: 'profile-id',
            name: 'Adeyemi',
            pin: '123',
            defaultCurrencyCode: 'NGN',
            createdAt: tCreatedAt,
          ),
        );

        expect(result, isA<Left<Failure, UserProfile>>());
        verifyNever(() => mockRepository.createProfile(any()));
      },
    );

    test(
      'returns Left(ValidationFailure) when pin contains non-digit characters',
      () async {
        final result = await useCase(
          CreateProfileParams(
            id: 'profile-id',
            name: 'Adeyemi',
            pin: '12a4',
            defaultCurrencyCode: 'NGN',
            createdAt: tCreatedAt,
          ),
        );

        expect(result, isA<Left<Failure, UserProfile>>());
        verifyNever(() => mockRepository.createProfile(any()));
      },
    );

    test(
      'returns Left(ValidationFailure) when defaultCurrencyCode is empty',
      () async {
        final result = await useCase(
          CreateProfileParams(
            id: 'profile-id',
            name: 'Adeyemi',
            pin: null,
            defaultCurrencyCode: '',
            createdAt: tCreatedAt,
          ),
        );

        expect(result, isA<Left<Failure, UserProfile>>());
        verifyNever(() => mockRepository.createProfile(any()));
      },
    );
  });
}
