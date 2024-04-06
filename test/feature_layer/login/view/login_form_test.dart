import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:firebase_login/feature_layer/login/login.dart';
import 'package:firebase_login/feature_layer/login/models/models.dart';
import 'package:firebase_login/feature_layer/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

class MockEmail extends Mock implements Email {}

class MockPassword extends Mock implements Password {}

void main() {
  const loginButtonKey = Key('loginForm_continue_raisedButton');
  const signInWithGoogleButtonKey = Key('loginForm_googleLogin_raisedButton');
  const emailInputKey = Key('loginForm_emailInput_textField');
  const passwordInputKey = Key('loginForm_passwordInput_textField');
  const createAccountButtonKey = Key('loginForm_createAccount_flatButton');

  const testEmail = 'test@gmail.com';
  const testPassword = 'testPssw0rd1';
  const invalidEmail = 'invalid email';

  group('LoginForm', () {
    late LoginCubit loginCubit;

    setUp(() {
      loginCubit = MockLoginCubit();
      when(() => loginCubit.state).thenReturn(const LoginState());
      when(() => loginCubit.onLogInWithGoogle()).thenAnswer((_) async {});
      when(() => loginCubit.onLogInWithCredentials()).thenAnswer((_) async {});
    });

    group('calls', () {
      testWidgets('emailChanged when email changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginPage(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(emailInputKey), testEmail);
        verify(() => loginCubit.onEmailChanged(testEmail)).called(1);
      });

      testWidgets('passwordChanged when password changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginPage(),
              ),
            ),
          ),
        );
        await tester.enterText(find.byKey(passwordInputKey), testPassword);
        verify(() => loginCubit.onPasswordChanged(testPassword)).called(1);
      });

      testWidgets('logInWithCredentials when login button is pressed',
          (tester) async {
        when(() => loginCubit.state).thenReturn(
          const LoginState(
            loginForm: LoginForm(
              email: Email.dirty(testEmail),
              password: Password.dirty(testPassword),
            ),
          ),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginPage(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(loginButtonKey));
        verify(() => loginCubit.onLogInWithCredentials()).called(1);
      });

      testWidgets('logInWithGoogle when sign in with google button is pressed',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginPage(),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(signInWithGoogleButtonKey));
        verify(() => loginCubit.onLogInWithGoogle()).called(1);
      });
    });

    group('renders', () {
      testWidgets('AuthenticationFailure SnackBar when submission fails',
          (tester) async {
        whenListen(
          loginCubit,
          Stream.fromIterable(const <LoginState>[
            LoginState(status: FormzSubmissionStatus.inProgress),
            LoginState(status: FormzSubmissionStatus.failure),
          ]),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginPage(),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('Authentication Failure'), findsOneWidget);
      });

      testWidgets('invalid email error text when email is invalid',
          (tester) async {
        final email = MockEmail();
        when(() => email.displayError).thenReturn(EmailValidationError.invalid);
        when(() => loginCubit.state).thenReturn(
            const LoginState(
            loginForm: LoginForm(email: Email.dirty(invalidEmail)),
          ),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginPage(),
              ),
            ),
          ),
        );
        expect(find.text('invalid email'), findsOneWidget);
      });

      testWidgets('invalid password error text when password is invalid',
          (tester) async {
        final password = MockPassword();
        when(
          () => password.displayError,
        ).thenReturn(PasswordValidationError.invalid);
        when(() => loginCubit.state).thenReturn(
           LoginState(
            loginForm: LoginForm(password: password),
          ),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginPage(),
              ),
            ),
          ),
        );
        expect(find.text('invalid password'), findsOneWidget);
      });

      testWidgets('disabled login button when status is not validated',
          (tester) async {
        when(() => loginCubit.state).thenReturn(const LoginState());
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginPage(),
              ),
            ),
          ),
        );
        final loginButton = tester.widget<ElevatedButton>(
          find.byKey(loginButtonKey),
        );
        expect(loginButton.enabled, isFalse);
      });

      testWidgets('enabled login button when status is validated',
          (tester) async {
        when(() => loginCubit.state).thenReturn(
          const LoginState(
            loginForm: LoginForm(
              email: Email.dirty(testEmail),
              password: Password.dirty(testPassword),
            ),
          ),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginPage(),
              ),
            ),
          ),
        );
        final loginButton = tester.widget<ElevatedButton>(
          find.byKey(loginButtonKey),
        );
        expect(loginButton.enabled, isTrue);
      });

      testWidgets('Sign in with Google Button', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: loginCubit,
                child: const LoginPage(),
              ),
            ),
          ),
        );
        expect(find.byKey(signInWithGoogleButtonKey), findsOneWidget);
      });
    });

    group('navigates', () {
      testWidgets('to SignUpPage when Create Account is pressed',
          (tester) async {
        await tester.pumpWidget(
          RepositoryProvider<AuthenticationRepository>(
            create: (_) => MockAuthenticationRepository(),
            child: MaterialApp(
              home: Scaffold(
                body: BlocProvider.value(
                  value: loginCubit,
                  child: const LoginPage(),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(createAccountButtonKey));
        await tester.pumpAndSettle();
        expect(find.byType(SignUpView), findsOneWidget);
      });
    });
  });
}
