import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:firebase_login/feature_layer/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  group('LoginPage', () {
    test('has a page', () {
      expect(LoginView.page(), isA<MaterialPage<void>>());
    });

    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => MockAuthenticationRepository(),
          child: const MaterialApp(home: LoginView()),
        ),
      );
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
