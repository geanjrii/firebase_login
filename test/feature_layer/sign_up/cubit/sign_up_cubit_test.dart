// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:firebase_login/feature_layer/login/models/models.dart';
import 'package:firebase_login/feature_layer/sign_up/sign_up.dart';
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

  const invalidConfirmedPasswordString = 'invalid';
  const invalidConfirmedPassword = ConfirmedPassword.dirty(
    password: validPasswordString,
    value: invalidConfirmedPasswordString,
  );

  const validConfirmedPasswordString = 't0pS3cret1234';
  const validConfirmedPassword = ConfirmedPassword.dirty(
    password: validPasswordString,
    value: validConfirmedPasswordString,
  );

  const validForm = SignUpForm(
      email: validEmail,
      password: validPassword,
      confirmedPassword: validConfirmedPassword);

  const validFormSignUpState = SignUpState(signUpForm: validForm);

  group('SignUpCubit', () {
    late AuthenticationRepository authenticationRepository;
    late SignUpCubit signUpCubit;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(
        () => authenticationRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});
      signUpCubit = SignUpCubit(authenticationRepository);
    });

    tearDown(() => signUpCubit.close());

    test('initial state is SignUpState', () {
      expect(signUpCubit.state, SignUpState());
    });

    group('emailChanged', () {
      blocTest<SignUpCubit, SignUpState>(
        'emits [invalid] when email/password/confirmedPassword are invalid',
        build: () => signUpCubit,
        act: (cubit) => cubit.onEmailChanged(invalidEmailString),
        expect: () =>
            const [SignUpState(signUpForm: SignUpForm(email: invalidEmail))],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when email/password/confirmedPassword are valid',
        build: () => signUpCubit,
        seed: () => SignUpState(
            signUpForm: SignUpForm(
                email: invalidEmail,
                password: validPassword,
                confirmedPassword: validConfirmedPassword)),
        act: (cubit) => cubit.onEmailChanged(validEmailString),
        expect: () => const [validFormSignUpState],
      );
    });

    group('passwordChanged', () {
      blocTest<SignUpCubit, SignUpState>(
        'emits [invalid] when email/password/confirmedPassword are invalid',
        build: () => signUpCubit,
        act: (cubit) => cubit.onPasswordChanged(invalidPasswordString),
        expect: () => const <SignUpState>[
          SignUpState(
            signUpForm: SignUpForm(
              confirmedPassword: ConfirmedPassword.dirty(
                password: invalidPasswordString,
              ),
              password: invalidPassword,
            ),
          ),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when email/password/confirmedPassword are valid',
        build: () => signUpCubit,
        seed: () => SignUpState(
            signUpForm: SignUpForm(
                email: validEmail,
                password: invalidPassword,
                confirmedPassword: validConfirmedPassword)),
        act: (cubit) => cubit.onPasswordChanged(validPasswordString),
        expect: () => const [validFormSignUpState],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when confirmedPasswordChanged is called first and then '
        'passwordChanged is called',
        build: () => signUpCubit,
        seed: () => SignUpState(
            signUpForm: SignUpForm(
                email: validEmail,
                password: invalidPassword,
                confirmedPassword: invalidConfirmedPassword)),
        act: (cubit) => cubit
          ..onConfirmedPasswordChanged(validConfirmedPasswordString)
          ..onPasswordChanged(validPasswordString),
        expect: () => const [
          SignUpState(
              signUpForm: SignUpForm(
                  email: validEmail,
                  password: invalidPassword,
                  confirmedPassword: validConfirmedPassword)),
          validFormSignUpState
        ],
      );
    });

    group('confirmedPasswordChanged', () {
      blocTest<SignUpCubit, SignUpState>(
        'emits [invalid] when email/password/confirmedPassword are invalid',
        build: () => signUpCubit,
        act: (cubit) {
          cubit.onConfirmedPasswordChanged(invalidConfirmedPasswordString);
        },
        expect: () => const [
          SignUpState(
              signUpForm:
                  SignUpForm(confirmedPassword: invalidConfirmedPassword)),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when email/password/confirmedPassword are valid',
        build: () => signUpCubit,
        seed: () => SignUpState(
            signUpForm: SignUpForm(
                email: validEmail,
                password: validPassword,
                confirmedPassword: invalidConfirmedPassword)),
        act: (cubit) => cubit.onConfirmedPasswordChanged(
          validConfirmedPasswordString,
        ),
        expect: () => const [validFormSignUpState],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [valid] when passwordChanged is called first and then '
        'confirmedPasswordChanged is called',
        build: () => signUpCubit,
        seed: () => SignUpState(
            signUpForm: SignUpForm(
                email: validEmail,
                password: invalidPassword,
                confirmedPassword: invalidConfirmedPassword)),
        act: (cubit) => cubit
          ..onPasswordChanged(validPasswordString)
          ..onConfirmedPasswordChanged(validConfirmedPasswordString),
        expect: () => const [
          SignUpState(
            signUpForm: SignUpForm(email: validEmail, password: validPassword, confirmedPassword: invalidConfirmedPassword),
          ),
          validFormSignUpState
        ],
      );
    });

    group('signUpFormSubmitted', () {
      blocTest<SignUpCubit, SignUpState>(
        'does nothing when status is not validated',
        build: () => signUpCubit,
        act: (cubit) => cubit.onSignUpFormSubmitted(),
        expect: () => const <SignUpState>[],
      );

      blocTest<SignUpCubit, SignUpState>(
        'calls signUp with correct email/password/confirmedPassword',
        build: () => signUpCubit,
        seed: () => validFormSignUpState,
        act: (cubit) => cubit.onSignUpFormSubmitted(),
        verify: (_) {
          verify(
            () => authenticationRepository.signUp(
              email: validEmailString,
              password: validPasswordString,
            ),
          ).called(1);
        },
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [inProgress, success] '
        'when signUp succeeds',
        build: () => signUpCubit,
        seed: () => validFormSignUpState,
        act: (cubit) => cubit.onSignUpFormSubmitted(),
        expect: () => const <SignUpState>[
          SignUpState(
              status: FormzSubmissionStatus.inProgress, signUpForm: validForm),
          SignUpState(
              status: FormzSubmissionStatus.success, signUpForm: validForm),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [inProgress, failure] '
        'when signUp fails due to SignUpWithEmailAndPasswordFailure',
        setUp: () {
          when(
            () => authenticationRepository.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(SignUpWithEmailAndPasswordFailure('oops'));
        },
        build: () => signUpCubit,
        seed: () => validFormSignUpState,
        act: (cubit) => cubit.onSignUpFormSubmitted(),
        expect: () => const <SignUpState>[
          SignUpState(
              status: FormzSubmissionStatus.inProgress, signUpForm: validForm),
          SignUpState(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'oops',
              signUpForm: validForm),
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'emits [inProgress, failure] '
        'when signUp fails due to generic exception',
        setUp: () {
          when(
            () => authenticationRepository.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => signUpCubit,
        seed: () => validFormSignUpState,
        act: (cubit) => cubit.onSignUpFormSubmitted(),
        expect: () => const <SignUpState>[
          SignUpState(
              status: FormzSubmissionStatus.inProgress, signUpForm: validForm),
          SignUpState(
              status: FormzSubmissionStatus.failure, signUpForm: validForm),
        ],
      );
    });
  });
}
