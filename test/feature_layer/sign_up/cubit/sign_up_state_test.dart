// ignore_for_file: prefer_const_constructors
import 'package:firebase_login/feature_layer/login/models/models.dart';
import 'package:firebase_login/feature_layer/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';

void main() {
  const email = Email.dirty('email');
  const passwordString = 'password';
  const password = Password.dirty(passwordString);
  const confirmedPassword = ConfirmedPassword.dirty(
    password: passwordString,
    value: passwordString,
  );

  group('SignUpState', () {
    test('supports value comparisons', () {
      expect(SignUpState(), SignUpState());
    });

    test('returns same object when no properties are passed', () {
      expect(SignUpState().copyWith(), SignUpState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        SignUpState().copyWith(status: FormzSubmissionStatus.initial),
        SignUpState(),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        SignUpState().copyWith(signUpForm: SignUpForm(email: email)),
        SignUpState(signUpForm: SignUpForm(email: email)),
      );
    });

    test('returns object with updated password when password is passed', () {
      expect(
        SignUpState().copyWith(signUpForm: SignUpForm(password: password)),
        SignUpState(signUpForm: SignUpForm(password: password)),
      );
    });

    test(
        'returns object with updated confirmedPassword'
        ' when confirmedPassword is passed', () {
      expect(
        SignUpState().copyWith(
            signUpForm: SignUpForm(confirmedPassword: confirmedPassword)),
        SignUpState(
            signUpForm: SignUpForm(confirmedPassword: confirmedPassword)),
      );
    });
  });
}
