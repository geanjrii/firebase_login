import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:firebase_login/feature_layer/authentication/authentication.dart';
import 'package:firebase_login/feature_layer/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppBloc extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockUser extends Mock implements User {}

void main() {
  const logoutButtonKey = Key('homePage_logout_iconButton');
  group('HomePage', () {
    late AuthenticationBloc appBloc;
    late User user;

    setUp(() {
      appBloc = MockAppBloc();
      user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state)
          .thenReturn(AuthenticationState.authenticated(user));
    });

    group('calls', () {
      testWidgets('AppLogoutRequested when logout is pressed', (tester) async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(home: HomePage()),
          ),
        );
        await tester.tap(find.byKey(logoutButtonKey));
        verify(() => appBloc.add(const AuthenticationLogoutRequested()))
            .called(1);
      });
    });

    group('renders', () {
      testWidgets('avatar widget', (tester) async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(home: HomePage()),
          ),
        );
        expect(find.byType(Avatar), findsOneWidget);
      });

      testWidgets('email address', (tester) async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(home: HomePage()),
          ),
        );
        expect(find.text('test@gmail.com'), findsOneWidget);
      });

      testWidgets('name', (tester) async {
        when(() => user.name).thenReturn('Joe');
        await tester.pumpWidget(
          BlocProvider.value(
            value: appBloc,
            child: const MaterialApp(home: HomePage()),
          ),
        );
        expect(find.text('Joe'), findsOneWidget);
      });
    });
  });
}
