import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:firebase_login/feature_layer/authentication/authentication.dart';
import 'package:firebase_login/feature_layer/home/home.dart';
import 'package:firebase_login/feature_layer/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockAppBloc extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

void main() {
  group('App', () {
    late AuthenticationRepository authenticationRepository;
    late User user;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      user = MockUser();
      when(() => authenticationRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => authenticationRepository.currentUser).thenReturn(user);
      when(() => user.isNotEmpty).thenReturn(true);
      when(() => user.isEmpty).thenReturn(false);
      when(() => user.email).thenReturn('test@gmail.com');
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        // const AuthenticationView( ),
        RepositoryProvider.value(
          value: authenticationRepository,
          child: const MaterialApp(
            // home: BlocProvider.value(
            // value: appBloc,
            // child:
            home: AuthenticationView(),
            // ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(AuthenticationPage), findsOneWidget);
    });
  });

  group('AppView', () {
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc appBloc;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      appBloc = MockAppBloc();
    });

    testWidgets('navigates to LoginPage when unauthenticated', (tester) async {
      when(() => appBloc.state)
          .thenReturn(const AuthenticationState.unauthenticated());
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: appBloc,
              child: const AuthenticationPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginView), findsOneWidget);
    });

    testWidgets('navigates to HomePage when authenticated', (tester) async {
      final user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state)
          .thenReturn(AuthenticationState.authenticated(user));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: appBloc,
              child: const AuthenticationPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
