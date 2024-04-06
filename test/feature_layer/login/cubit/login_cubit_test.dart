// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:firebase_login/feature_layer/login/login.dart';
import 'package:firebase_login/feature_layer/login/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  const invalidPasswordString = 'invalid';
  const invalidPassword = Password.dirty(invalidPasswordString);

  const validPasswordString = 't0pS3cret1234';
  const validPassword = Password.dirty(validPasswordString);

  group('LoginCubit', () {
    late AuthenticationRepository authenticationRepository;
    late LoginCubit loginCubit;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(
        () => authenticationRepository.logInWithGoogle(),
      ).thenAnswer((_) async {});
      when(
        () => authenticationRepository.logInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});
      loginCubit = LoginCubit(authenticationRepository);
    });

    tearDown(() => loginCubit.close());

    test('initial state is LoginState', () {
      expect(loginCubit.state, LoginState());
    });

    group('emailChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => loginCubit,
        act: (cubit) => cubit.onEmailChanged(invalidEmailString),
        expect: () => const <LoginState>[LoginState(email: invalidEmail)],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => loginCubit,
        seed: () => LoginState(password: validPassword),
        act: (cubit) => cubit.onEmailChanged(validEmailString),
        expect: () => const <LoginState>[
          LoginState(
            email: validEmail,
            password: validPassword,
            isValid: true,
          ),
        ],
      );
    });

    group('passwordChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => loginCubit,
        act: (cubit) => cubit.onPasswordChanged(invalidPasswordString),
        expect: () => const <LoginState>[LoginState(password: invalidPassword)],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => loginCubit,
        seed: () => LoginState(email: validEmail),
        act: (cubit) => cubit.onPasswordChanged(validPasswordString),
        expect: () => const <LoginState>[
          LoginState(
            email: validEmail,
            password: validPassword,
            isValid: true,
          ),
        ],
      );
    });

    group('logInWithCredentials', () {
      blocTest<LoginCubit, LoginState>(
        'does nothing when status is not validated',
        build: () => loginCubit,
        act: (cubit) => cubit.onLogInWithCredentials(),
        expect: () => const <LoginState>[],
      );

      blocTest<LoginCubit, LoginState>(
        'calls logInWithEmailAndPassword with correct email/password',
        build: () => loginCubit,
        seed: () => LoginState(
          email: validEmail,
          password: validPassword,
          isValid: true,
        ),
        act: (cubit) => cubit.onLogInWithCredentials(),
        verify: (_) {
          verify(
            () => authenticationRepository.logInWithEmailAndPassword(
              email: validEmailString,
              password: validPasswordString,
            ),
          ).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithEmailAndPassword succeeds',
        build: () => loginCubit,
        seed: () => LoginState(
          email: validEmail,
          password: validPassword,
          isValid: true,
        ),
        act: (cubit) => cubit.onLogInWithCredentials(),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            password: validPassword,
            isValid: true,
          ),
          LoginState(
            status: FormzSubmissionStatus.success,
            email: validEmail,
            password: validPassword,
            isValid: true,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithEmailAndPassword fails '
        'due to LogInWithEmailAndPasswordFailure',
        setUp: () {
          when(
            () => authenticationRepository.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(LogInWithEmailAndPasswordFailure('oops'));
        },
        build: () => loginCubit,
        seed: () => LoginState(
          email: validEmail,
          password: validPassword,
          isValid: true,
        ),
        act: (cubit) => cubit.onLogInWithCredentials(),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            password: validPassword,
            isValid: true,
          ),
          LoginState(
            status: FormzSubmissionStatus.failure,
            errorMessage: 'oops',
            email: validEmail,
            password: validPassword,
            isValid: true,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithEmailAndPassword fails due to generic exception',
        setUp: () {
          when(
            () => authenticationRepository.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => loginCubit,
        seed: () => LoginState(
          email: validEmail,
          password: validPassword,
          isValid: true,
        ),
        act: (cubit) => cubit.onLogInWithCredentials(),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            password: validPassword,
            isValid: true,
          ),
          LoginState(
            status: FormzSubmissionStatus.failure,
            email: validEmail,
            password: validPassword,
            isValid: true,
          ),
        ],
      );
    });

    group('logInWithGoogle', () {
      blocTest<LoginCubit, LoginState>(
        'calls logInWithGoogle',
        build: () => loginCubit,
        act: (cubit) => cubit.onLogInWithGoogle(),
        verify: (_) {
          verify(() => authenticationRepository.logInWithGoogle()).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, success] '
        'when logInWithGoogle succeeds',
        build: () => loginCubit,
        act: (cubit) => cubit.onLogInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.success),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, failure] '
        'when logInWithGoogle fails due to LogInWithGoogleFailure',
        setUp: () {
          when(
            () => authenticationRepository.logInWithGoogle(),
          ).thenThrow(LogInWithGoogleFailure('oops'));
        },
        build: () => loginCubit,
        act: (cubit) => cubit.onLogInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(
            status: FormzSubmissionStatus.failure,
            errorMessage: 'oops',
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, failure] '
        'when logInWithGoogle fails due to generic exception',
        setUp: () {
          when(
            () => authenticationRepository.logInWithGoogle(),
          ).thenThrow(Exception('oops'));
        },
        build: () => loginCubit,
        act: (cubit) => cubit.onLogInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.failure),
        ],
      );
    });
  });
}
