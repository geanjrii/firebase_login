// ignore_for_file: prefer_const_constructors
import 'package:firebase_login/feature_layer/login/login.dart';
import 'package:firebase_login/feature_layer/login/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';

void main() {
  const mockEmail = Email.dirty('email');
  const mockPassword = Password.dirty('password');

  group('LoginState', () {
    test('supports value comparisons', () {
      expect(LoginState(), LoginState());
    });

    test('returns same object when no properties are passed', () {
      expect(LoginState().copyWith(), LoginState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        LoginState().copyWith(status: FormzSubmissionStatus.initial),
        LoginState(),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        LoginState().copyWith(loginForm: LoginForm(email: mockEmail)),
        LoginState(loginForm: LoginForm(email: mockEmail)),
      );
    });

    test('returns object with updated password when password is passed', () {
      expect(
        LoginState().copyWith(loginForm: LoginForm(password: mockPassword)),
        LoginState(loginForm: LoginForm(password: mockPassword)),
      );
    });
  });
}
