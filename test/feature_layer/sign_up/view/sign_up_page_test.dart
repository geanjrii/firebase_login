// ignore_for_file: prefer_const_constructors
import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:firebase_login/feature_layer/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  group('SignUpPage', () {
    test('has a route', () {
      expect(SignUpView.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets('renders a SignUpForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => MockAuthenticationRepository(),
          child: MaterialApp(home: SignUpView()),
        ),
      );
      expect(find.byType(SignUpPage), findsOneWidget);
    });
  });
}
